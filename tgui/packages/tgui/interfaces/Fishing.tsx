import { type CSSProperties, useEffect, useRef, useState } from 'react';
import { KeyListener } from 'tgui-core/components';
import { globalEvents, type KeyEvent } from 'tgui-core/events';
import { KEY_CTRL } from 'tgui-core/keycodes';
import { clamp } from 'tgui-core/math';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type MoverId = 'default' | 'accelerando' | 'choppy' | 'plunger';

type ActiveEffect = 'antigrav' | 'camo';

type MoverData = {
  id: MoverId;
  short_jump_chance: number;
  long_jump_chance: number;
  short_jump_velocity_limit: number;
  long_jump_velocity_limit: number;
  idle_velocity: number;
  can_interrupt_move: boolean;
  acceleration: number;
  accel_time_cap?: number;
  plunging_speed?: number;
};

type FishingData = {
  difficulty: number;
  background: string;
  frame: string;
  fish_icon: string;
  fish_height: number;
  fish_position: number;
  bait_height: number;
  base_bait_height: number;
  bait_position: number;
  completion: number;
  completion_gain: number;
  completion_loss: number;
  gravity_velocity: number;
  reeling_velocity: number;
  max_bait_velocity: number;
  bait_bounce_mult: number;
  deceleration_mult: number;
  overlap_velocity_mult: number;
  auto_reel: boolean;
  bidirectional: boolean;
  no_escape: boolean;
  active_effects: ActiveEffect[];
  mover: MoverData;
  catch_band_grace: number;
  clean_catch_ratio: number;
  fair_catch_ratio: number;
};

enum ReelingState {
  Idle,
  Reeling,
  ReelingDown,
}

const MINIGAME_AREA = 1000;
const TICK_SECONDS = 0.05;
const MAX_FRAME_SECONDS = 0.25;
const BAIT_MIN_VELOCITY_BOUNCE = 150;
const FISH_TARGET_MIN_DISTANCE = 6;
const FISH_FRICTION_MULT = 0.9;
const FISH_SHORT_JUMP_MIN_DISTANCE = 100;
const FISH_SHORT_JUMP_MAX_DISTANCE = 200;

const HUD_SCALE = 4;
const HUD_WIDTH = 32;
const HUD_HEIGHT = 96;
const MINIGAME_SLIDER_HEIGHT = 76;
const MINIGAME_BAIT_HEIGHT = 27;
const MINIGAME_BAIT_TOP_AND_BOTTOM_HEIGHT = 6;
const MINIGAME_COMPLETION_BAR_TOP = 14;
const MINIGAME_COMPLETION_BAR_HEIGHT = 80;

const dmRand = (low: number, high: number) =>
  Math.floor(Math.random() * (high - low + 1)) + low;

const dmProb = (chance: number) => Math.random() * 100 < chance;

const roundTo = (value: number, step: number) =>
  Math.round(value / step) * step;

type FinishCallbacks = {
  win: (fightTime: number, onFishTime: number) => void;
  lose: () => void;
  effect: (effect: ActiveEffect, active: boolean) => void;
};

class FishingSim {
  data: FishingData;
  callbacks: FinishCallbacks;
  done = false;
  reeling = ReelingState.Idle;

  fishPosition: number;
  previousFishPosition: number;
  fishVelocity = 0;
  targetPosition: number | null = null;
  currentVelocityLimit = 0;
  timesFired = 0;
  shortJumpVelocityLimit: number;
  longJumpVelocityLimit: number;
  idleVelocity: number;
  shortJumpVelocityAdd = 0;
  longJumpVelocityAdd = 0;
  fauxPosition: number;
  isPlunging = true;

  baitPosition: number;
  previousBaitPosition: number;
  baitVelocity = 0;

  completion: number;
  fightTime = 0;
  onFishTime = 0;

  elapsed = 0;
  activeEffect: ActiveEffect | null = null;
  effectCooldownEnd = 0;

  constructor(data: FishingData, callbacks: FinishCallbacks) {
    this.data = data;
    this.callbacks = callbacks;
    this.fishPosition = data.fish_position;
    this.previousFishPosition = data.fish_position;
    this.fauxPosition = data.fish_position;
    this.baitPosition = data.bait_position;
    this.previousBaitPosition = data.bait_position;
    this.completion = data.completion;
    this.shortJumpVelocityLimit = data.mover.short_jump_velocity_limit;
    this.longJumpVelocityLimit = data.mover.long_jump_velocity_limit;
    this.idleVelocity = data.mover.idle_velocity;
    if (data.active_effects.length) {
      this.effectCooldownEnd = dmRand(5, 9);
    }
  }

  tick(seconds: number) {
    this.previousFishPosition = this.fishPosition;
    this.previousBaitPosition = this.baitPosition;
    this.elapsed += seconds;
    if (
      this.data.active_effects.length &&
      this.elapsed >= this.effectCooldownEnd
    ) {
      this.selectActiveEffect();
    }
    this.moveFish(seconds);
    if (this.data.auto_reel) {
      this.moveTowardsFish();
    }
    this.moveBait(seconds);
  }

  selectActiveEffect() {
    if (this.activeEffect === null) {
      const effects = this.data.active_effects;
      this.activeEffect = effects[Math.floor(Math.random() * effects.length)];
      this.effectCooldownEnd =
        this.elapsed +
        (this.activeEffect === 'antigrav' ? dmRand(6, 9) : dmRand(6, 8));
      this.callbacks.effect(this.activeEffect, true);
      return;
    }
    this.effectCooldownEnd =
      this.elapsed +
      (this.activeEffect === 'antigrav' ? dmRand(10, 13) : dmRand(9, 16));
    this.callbacks.effect(this.activeEffect, false);
    this.activeEffect = null;
  }

  fishArea() {
    return MINIGAME_AREA - this.data.fish_height;
  }

  moveFish(seconds: number) {
    const mover = this.data.mover;
    if (mover.id === 'accelerando') {
      this.accelerate(seconds);
    } else if (mover.id === 'plunger') {
      this.plunge();
    }

    this.timesFired++;
    const canRoll = this.timesFired % 2 === 1;

    if (
      this.targetPosition !== null &&
      Math.abs(this.targetPosition - this.fishPosition) <
        FISH_TARGET_MIN_DISTANCE
    ) {
      this.targetPosition = null;
    }

    if (
      canRoll &&
      (mover.can_interrupt_move || this.targetPosition === null) &&
      dmProb(mover.long_jump_chance)
    ) {
      const distanceFromTop =
        MINIGAME_AREA - this.fishPosition - this.data.fish_height;
      const distanceFromBottom = this.fishPosition;
      const topChance =
        distanceFromTop < FISH_SHORT_JUMP_MIN_DISTANCE
          ? 0
          : (distanceFromTop / Math.max(distanceFromBottom, 1)) * 100;
      let newTarget = this.fishPosition;
      if (dmProb(topChance)) {
        newTarget += (distanceFromTop * dmRand(75, 100)) / 100;
      } else {
        newTarget -= (distanceFromBottom * dmRand(75, 100)) / 100;
      }
      this.targetPosition = Math.floor(newTarget);
      this.currentVelocityLimit = this.longJumpVelocityLimit;
    }

    if (this.targetPosition !== null) {
      const distance = this.targetPosition - this.fishPosition;
      const accelerationMult = this.getAcceleration(seconds);
      let targetAcceleration = distance * accelerationMult * seconds;
      if (this.idleVelocity) {
        const absIdleVelocity = Math.abs(this.idleVelocity);
        if (Math.sign(this.idleVelocity) !== Math.sign(targetAcceleration)) {
          const halvedRatio = (accelerationMult * 0.5) / absIdleVelocity;
          if (halvedRatio < 1) {
            const power = Math.min(halvedRatio + 0.5, 1);
            targetAcceleration *= 1 - halvedRatio ** power;
          } else {
            targetAcceleration += this.idleVelocity;
          }
        }
      }
      this.fishVelocity =
        this.fishVelocity * FISH_FRICTION_MULT + targetAcceleration;
    } else if (canRoll && dmProb(mover.short_jump_chance)) {
      const distanceFromTop =
        MINIGAME_AREA - this.fishPosition - this.data.fish_height;
      const distanceFromBottom = this.fishPosition;
      let jumpLength = 0;
      if (distanceFromTop >= FISH_SHORT_JUMP_MIN_DISTANCE) {
        jumpLength = dmRand(
          FISH_SHORT_JUMP_MIN_DISTANCE,
          FISH_SHORT_JUMP_MAX_DISTANCE,
        );
      }
      if (
        distanceFromBottom >= FISH_SHORT_JUMP_MIN_DISTANCE &&
        (!jumpLength || dmProb(50))
      ) {
        jumpLength = -dmRand(
          FISH_SHORT_JUMP_MIN_DISTANCE,
          FISH_SHORT_JUMP_MAX_DISTANCE,
        );
      }
      this.targetPosition = clamp(
        this.fishPosition + jumpLength,
        0,
        this.fishArea(),
      );
      this.currentVelocityLimit = this.shortJumpVelocityLimit;
    }

    this.fishVelocity = clamp(
      this.fishVelocity,
      -this.currentVelocityLimit,
      this.currentVelocityLimit,
    );
    this.setFishPosition(seconds);
  }

  getAcceleration(seconds: number) {
    const mover = this.data.mover;
    const acceleration = mover.acceleration;
    if (mover.id !== 'accelerando') {
      return acceleration;
    }
    return (
      acceleration +
      Math.min(
        acceleration,
        (acceleration * this.timesFired * seconds) / mover.accel_time_cap!,
      )
    );
  }

  accelerate(seconds: number) {
    const timeCap = this.data.mover.accel_time_cap!;
    if (this.timesFired * seconds >= timeCap) {
      return;
    }
    if (!this.timesFired) {
      this.shortJumpVelocityAdd = this.shortJumpVelocityLimit / timeCap;
      this.longJumpVelocityAdd = this.longJumpVelocityLimit / timeCap;
      return;
    }
    if (this.currentVelocityLimit) {
      const velocityAdd =
        this.currentVelocityLimit === this.shortJumpVelocityLimit
          ? this.shortJumpVelocityAdd
          : this.longJumpVelocityAdd;
      this.currentVelocityLimit += roundTo(velocityAdd * seconds, 0.01);
    }
    this.shortJumpVelocityLimit += roundTo(
      this.shortJumpVelocityAdd * seconds,
      0.01,
    );
    this.longJumpVelocityLimit += roundTo(
      this.longJumpVelocityAdd * seconds,
      0.01,
    );
  }

  plunge() {
    const fishArea = this.fishArea();
    const plungingSpeed = this.data.mover.plunging_speed!;
    if (this.isPlunging) {
      if (
        this.targetPosition !== null &&
        this.targetPosition > this.fishPosition
      ) {
        this.targetPosition = null;
      }
      if (this.fishPosition / fishArea <= 0.04) {
        this.idleVelocity -= plungingSpeed;
        this.isPlunging = false;
      }
    } else if ((fishArea - this.fishPosition) / fishArea <= 0.04) {
      this.idleVelocity += plungingSpeed;
      this.isPlunging = true;
    }
  }

  setFishPosition(seconds: number) {
    const mover = this.data.mover;
    if (mover.id === 'accelerando') {
      this.fishVelocity = Math.floor(this.fishVelocity);
    }
    if (mover.id === 'choppy') {
      this.fauxPosition = clamp(
        this.fauxPosition + this.fishVelocity * seconds,
        0,
        this.fishArea(),
      );
      if (Math.floor(this.timesFired * 0.5) % 5 === 0) {
        this.fishPosition = this.fauxPosition;
      }
      return;
    }
    this.fishPosition = clamp(
      this.fishPosition + this.fishVelocity * seconds,
      0,
      this.fishArea(),
    );
  }

  moveTowardsFish() {
    const baitCenter = this.baitPosition + this.data.bait_height / 2;
    const fishCenter = this.fishPosition + this.data.fish_height / 2;
    const distance = fishCenter - baitCenter;
    if (Math.abs(distance) <= this.data.bait_height * 0.3) {
      this.reeling = ReelingState.Idle;
    } else if (distance > 0) {
      this.reeling = ReelingState.Reeling;
    } else {
      this.reeling = this.data.bidirectional
        ? ReelingState.ReelingDown
        : ReelingState.Idle;
    }
  }

  moveBait(seconds: number) {
    const data = this.data;
    const baitArea = MINIGAME_AREA - data.bait_height;
    const shouldBounce = Math.abs(this.baitVelocity) > BAIT_MIN_VELOCITY_BOUNCE;
    this.baitPosition += this.baitVelocity * seconds;
    if (this.baitPosition > baitArea) {
      this.baitPosition = baitArea;
      if (this.reeling === ReelingState.Reeling || !shouldBounce) {
        this.baitVelocity = 0;
      } else {
        this.baitVelocity = -this.baitVelocity * data.bait_bounce_mult;
      }
    } else if (this.baitPosition < 0) {
      this.baitPosition = 0;
      if (this.reeling === ReelingState.ReelingDown || !shouldBounce) {
        this.baitVelocity = 0;
      } else {
        this.baitVelocity = -this.baitVelocity * data.bait_bounce_mult;
      }
    }

    const startPosition = this.baitPosition - this.baitVelocity * seconds;
    const sweepTop = Math.min(startPosition, this.baitPosition);
    const sweepBottom =
      Math.max(startPosition, this.baitPosition) + data.bait_height;
    const fishTop = this.fishPosition;
    const fishBottom = this.fishPosition + data.fish_height;
    const fishOnBait = sweepBottom >= fishTop && fishBottom >= sweepTop;

    let velocityChange: number;
    switch (this.reeling) {
      case ReelingState.Reeling:
        velocityChange = data.reeling_velocity;
        break;
      case ReelingState.ReelingDown:
        velocityChange = -data.reeling_velocity;
        break;
      default:
        velocityChange =
          !data.bidirectional || this.baitVelocity > 0
            ? data.gravity_velocity
            : -data.gravity_velocity;
    }
    velocityChange = Math.floor(
      velocityChange *
        (fishOnBait ? data.overlap_velocity_mult : 1) *
        seconds,
    );
    if (this.activeEffect === 'antigrav') {
      velocityChange = -velocityChange;
    }

    if (this.baitVelocity > 0 && velocityChange < 0) {
      this.baitVelocity += Math.max(
        -this.baitVelocity,
        velocityChange * data.deceleration_mult,
      );
    } else if (this.baitVelocity < 0 && velocityChange > 0) {
      this.baitVelocity += Math.min(
        -this.baitVelocity,
        velocityChange * data.deceleration_mult,
      );
    }

    if (data.bidirectional && this.reeling === ReelingState.Idle) {
      if (velocityChange < 0) {
        this.baitVelocity = Math.max(this.baitVelocity + velocityChange, 0);
      } else if (velocityChange > 0) {
        this.baitVelocity = Math.min(this.baitVelocity + velocityChange, 0);
      }
    } else {
      this.baitVelocity += velocityChange;
    }

    this.fightTime += seconds;
    if (fishOnBait) {
      this.onFishTime += seconds;
      this.completion += data.completion_gain * seconds;
      if (this.completion >= 100) {
        this.finish(true);
      }
    } else {
      this.completion -= data.completion_loss * seconds;
      if (this.completion <= 0 && !data.no_escape) {
        this.finish(false);
      }
    }

    this.completion = clamp(this.completion, 0, 100);
    this.baitVelocity = clamp(
      this.baitVelocity,
      -data.max_bait_velocity,
      data.max_bait_velocity,
    );
  }

  finish(win: boolean) {
    if (this.done) {
      return;
    }
    this.done = true;
    if (win) {
      this.callbacks.win(this.fightTime, this.onFishTime);
    } else {
      this.callbacks.lose();
    }
  }

  catchBand() {
    const grace = this.data.catch_band_grace;
    const ratio = (this.onFishTime + grace) / (this.fightTime + grace);
    if (ratio >= this.data.clean_catch_ratio) {
      return 'completion_clean';
    }
    if (ratio >= this.data.fair_catch_ratio) {
      return 'completion_fair';
    }
    return 'completion_poor';
  }
}

type SpriteProps = {
  state: string;
  z?: number;
  style?: CSSProperties;
};

const Sprite = (props: SpriteProps) => {
  const { state, z = 0, style } = props;
  return (
    <div
      className={`fishing_hud32x96 ${state}`}
      style={{
        position: 'absolute',
        left: 0,
        top: 0,
        transform: `translateY(${-z}px)`,
        ...style,
      }}
    />
  );
};

type FishingMinigameProps = {
  data: FishingData;
  callbacks: FinishCallbacks;
};

const FishingMinigame = (props: FishingMinigameProps) => {
  const { data, callbacks } = props;
  const simRef = useRef<FishingSim | null>(null);
  if (simRef.current === null) {
    simRef.current = new FishingSim(data, callbacks);
  }
  const sim = simRef.current;
  const [interpolation, setInterpolation] = useState(0);

  useEffect(() => {
    let animationId = 0;
    let lastFrame: number | undefined;
    let accumulator = 0;
    const updateAnimation = (timestamp: DOMHighResTimeStamp) => {
      const last = lastFrame === undefined ? timestamp : lastFrame;
      lastFrame = timestamp;
      accumulator += Math.min((timestamp - last) / 1000, MAX_FRAME_SECONDS);
      while (accumulator >= TICK_SECONDS && !sim.done) {
        sim.tick(TICK_SECONDS);
        accumulator -= TICK_SECONDS;
      }
      setInterpolation(accumulator / TICK_SECONDS);
      if (!sim.done) {
        animationId = window.requestAnimationFrame(updateAnimation);
      }
    };
    animationId = window.requestAnimationFrame(updateAnimation);
    return () => window.cancelAnimationFrame(animationId);
  }, []);

  useEffect(() => {
    const startReeling = () => {
      if (!data.auto_reel && sim.reeling === ReelingState.Idle) {
        sim.reeling = ReelingState.Reeling;
      }
    };
    const stopReeling = () => {
      if (sim.reeling === ReelingState.Reeling) {
        sim.reeling = ReelingState.Idle;
      }
    };
    const startReelingDown = () => {
      if (
        !data.auto_reel &&
        data.bidirectional &&
        sim.reeling === ReelingState.Idle
      ) {
        sim.reeling = ReelingState.ReelingDown;
      }
    };
    const stopReelingDown = () => {
      if (sim.reeling === ReelingState.ReelingDown) {
        sim.reeling = ReelingState.Idle;
      }
    };
    const handleMouseDown = (event: MouseEvent) => {
      if (event.button === 2) {
        startReelingDown();
      } else {
        startReeling();
      }
    };
    const handleMouseUp = (event: MouseEvent) => {
      if (event.button === 2) {
        stopReelingDown();
      } else {
        stopReeling();
      }
    };
    const handleContextMenu = (event: MouseEvent) => event.preventDefault();
    document.addEventListener('mousedown', handleMouseDown);
    document.addEventListener('mouseup', handleMouseUp);
    document.addEventListener('contextmenu', handleContextMenu);
    globalEvents.on('byond/mousedown', startReeling);
    globalEvents.on('byond/mouseup', stopReeling);
    globalEvents.on('byond/ctrldown', startReelingDown);
    globalEvents.on('byond/ctrlup', stopReelingDown);
    return () => {
      document.removeEventListener('mousedown', handleMouseDown);
      document.removeEventListener('mouseup', handleMouseUp);
      document.removeEventListener('contextmenu', handleContextMenu);
      globalEvents.off('byond/mousedown', startReeling);
      globalEvents.off('byond/mouseup', stopReeling);
      globalEvents.off('byond/ctrldown', startReelingDown);
      globalEvents.off('byond/ctrlup', stopReelingDown);
    };
  }, []);

  const handleKeyDown = (keyEvent: KeyEvent) => {
    if (keyEvent.code === KEY_CTRL) {
      globalEvents.emit('byond/ctrldown');
    }
  };

  const handleKeyUp = (keyEvent: KeyEvent) => {
    if (keyEvent.code === KEY_CTRL) {
      globalEvents.emit('byond/ctrlup');
    }
  };

  const lerp = (from: number, to: number) =>
    from + (to - from) * interpolation;
  const toPixels = (position: number) =>
    (MINIGAME_SLIDER_HEIGHT * position) / MINIGAME_AREA;
  const baitZ = toPixels(lerp(sim.previousBaitPosition, sim.baitPosition));
  const fishZ = toPixels(lerp(sim.previousFishPosition, sim.fishPosition));
  const baitPixelHeight = Math.round(
    MINIGAME_BAIT_HEIGHT * (data.bait_height / data.base_bait_height),
  );
  const baitBars: number[] = [];
  for (
    let i = 1;
    i <= baitPixelHeight - MINIGAME_BAIT_TOP_AND_BOTTOM_HEIGHT;
    i++
  ) {
    baitBars.push(i);
  }
  const completionClip =
    MINIGAME_COMPLETION_BAR_TOP +
    MINIGAME_COMPLETION_BAR_HEIGHT * (1 - sim.completion * 0.01);
  const camouflaged = sim.activeEffect === 'camo';
  const background =
    sim.activeEffect === null
      ? data.background
      : `background_${sim.activeEffect}`;

  return (
    <div
      className="Fishing"
      style={{
        width: `${HUD_WIDTH * HUD_SCALE}px`,
        height: `${HUD_HEIGHT * HUD_SCALE}px`,
      }}
    >
      <KeyListener onKeyDown={handleKeyDown} onKeyUp={handleKeyUp} />
      <div
        className="Fishing__hud"
        style={{ transform: `scale(${HUD_SCALE})` }}
      >
        <Sprite state={background} />
        <Sprite state={data.frame} />
        <Sprite state="bait_bottom" z={baitZ} />
        {baitBars.map((offset) => (
          <Sprite key={offset} state="bait_bar" z={baitZ + offset} />
        ))}
        <Sprite
          state="bait_top"
          z={baitZ + baitPixelHeight - MINIGAME_BAIT_TOP_AND_BOTTOM_HEIGHT}
        />
        <Sprite
          state={data.fish_icon}
          z={fishZ}
          style={{
            opacity: camouflaged ? 7 / 255 : 1,
            transition: `opacity ${camouflaged ? 2 : 1.2}s linear`,
          }}
        />
        <Sprite
          state={sim.catchBand()}
          style={{ clipPath: `inset(${completionClip}px 0 0 0)` }}
        />
      </div>
    </div>
  );
};

export const Fishing = () => {
  const { act, data } = useBackend<FishingData>();
  const callbacksRef = useRef<FinishCallbacks>({
    win: (fightTime, onFishTime) =>
      act('win', { fight_time: fightTime, on_fish_time: onFishTime }),
    lose: () => act('lose'),
    effect: (effect, active) =>
      act('effect', { effect: effect, active: active ? 1 : 0 }),
  });
  return (
    <Window width={160} height={432} title="Fishing" theme="parchment">
      <Window.Content fitted>
        <div className="Fishing__container">
          {data.mover && (
            <FishingMinigame data={data} callbacks={callbacksRef.current} />
          )}
        </div>
      </Window.Content>
    </Window>
  );
};
