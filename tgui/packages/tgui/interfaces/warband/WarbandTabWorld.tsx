import { useRef, useState } from 'react';
import { Button, Section, Stack } from 'tgui-core/components';

import { CasusBelliPanel } from './WarbandCasusBelli';
import { CasusBelliProposal, CasusBelliTerm, NobleType } from './WarbandTypes';

type WorldTabProps = {
  nobleList: NobleType[];
  alliesList: NobleType[];
  act: (action: string, payload?: object) => void;
  proposals: CasusBelliProposal[];
  availableTerms: CasusBelliTerm[];
  userProposal: string | null;
  userVote: string | null;
  userVoteConfirmed: boolean;
  warlordSelectedProposal: string | null;
  warlordCasusBelli: CasusBelliTerm | null;
  isWarlord: boolean;
  locked?: boolean;
  factions: any[];
  territories: any[];
  lockedWarbandType: string | null;
};

const SPLIT_MIN = 80;
const SPLIT_DEFAULT = 220;

export const WorldTab = ({
  nobleList, alliesList, act,
  proposals, availableTerms,
  userProposal, userVote, userVoteConfirmed,
  warlordSelectedProposal, warlordCasusBelli,
  isWarlord, locked = false, factions, territories,
  lockedWarbandType,
}: WorldTabProps) => {
  const [casusBelliHeight, setCasusBelliHeight] = useState(SPLIT_DEFAULT);
  const containerRef = useRef<HTMLDivElement>(null);

  const handleDragStart = (e: React.MouseEvent) => {
    e.preventDefault();
    const startY = e.clientY;
    const startHeight = casusBelliHeight;

    const onMove = (ev: MouseEvent) => {
      const delta = ev.clientY - startY;
      const containerH = containerRef.current?.clientHeight ?? 600;
      const maxH = containerH - SPLIT_MIN - 8;
      setCasusBelliHeight(Math.max(SPLIT_MIN, Math.min(maxH, startHeight + delta)));
    };

    const onUp = () => {
      window.removeEventListener('mousemove', onMove);
      window.removeEventListener('mouseup', onUp);
    };

    window.addEventListener('mousemove', onMove);
    window.addEventListener('mouseup', onUp);
  };

  return (
    <Stack style={{ flex: 1, flexDirection: 'column', height: '100%' }}>
      <Stack.Item grow={1} style={{ minHeight: 0, display: 'flex', flexDirection: 'column' }}>
        <div ref={containerRef} style={{ display: 'flex', flexDirection: 'column', flex: 1, minHeight: 0 }}>
          <div style={{ height: casusBelliHeight, flexShrink: 0, overflow: 'hidden' }}>
            <CasusBelliPanel
              proposals={proposals} availableTerms={availableTerms}
              userProposal={userProposal} userVote={userVote} userVoteConfirmed={userVoteConfirmed}
              warlordSelectedProposal={warlordSelectedProposal}
              warlordCasusBelli={warlordCasusBelli}
              isWarlord={isWarlord} act={act}
              factions={factions ?? []} territories={territories ?? []}
              locked={locked}
              lockedWarbandType={lockedWarbandType}
            />
          </div>

          <div
            onMouseDown={handleDragStart}
            style={{
              height: '8px',
              flexShrink: 0,
              cursor: 'ns-resize',
              backgroundColor: '#1a0a0a',
              borderTop: '1px solid #5a2020',
              borderBottom: '1px solid #5a2020',
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              userSelect: 'none',
            }}
          >
            <div style={{ display: 'flex', gap: '3px', pointerEvents: 'none' }}>
              {[0, 1, 2, 3, 4].map((i) => (
                <div key={i} style={{
                  width: '3px', height: '3px',
                  borderRadius: '50%',
                  backgroundColor: '#7a3030',
                }} />
              ))}
            </div>
          </div>

          <div style={{ flex: 1, minHeight: 0, display: 'flex' }}>
            <Section
              title={<span style={{ color: '#7a2525ff' }}>KNOW THY ENEMIES</span>}
              scrollable fill style={{ flex: 1, minWidth: '300px' }}
            >
              {nobleList.length > 0 ? (
                <Stack vertical>
                  {nobleList.map((noble) => (
                    <Button
                      key={noble.name} tooltip={noble.name}
                      onClick={() => { act('interaction_sound'); act('view_vip', { enemy: noble.name }); }}
                      style={{ textAlign: 'center' }}
                    >
                      The {noble.job}
                    </Button>
                  ))}
                </Stack>
              ) : (
                <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
                  <p style={{ color: '#7a2525ff' }}>THERE ARE NO ENEMIES OF NOTE</p>
                </div>
              )}
            </Section>

            <Section
              title={<span style={{ color: '#7a2525ff' }}>KNOW THY FRIENDS</span>}
              scrollable fill style={{ flex: 1, minWidth: '300px' }}
            >
              {alliesList.length > 0 ? (
                <Stack vertical>
                  {alliesList.map((ally, index) => (
                    <Button
                      key={`${ally.name}-${index}`} tooltip={ally.name}
                      onClick={() => { act('interaction_sound'); if (!ally.in_lobby) act('view_vip', { ally: ally.name }); }}
                      disabled={ally.in_lobby}
                      style={{ textAlign: 'left', opacity: ally.in_lobby ? 0.7 : 1 }}
                    >
                      <Stack vertical>
                        {ally.in_lobby ? (
                          <>
                            <span style={{ fontWeight: 'bold' }}>
                              {ally.job === 'Aspirant Lieutenant' ? 'Lieutenant' : ally.job}
                              <span style={{ fontSize: '11px', marginLeft: '8px' }}>(In Lobby)</span>
                            </span>
                            <span style={{ fontSize: '12px', opacity: 0.9 }}>{ally.name}</span>
                          </>
                        ) : (
                          <>
                            <span style={{ fontWeight: 'bold' }}>{ally.name}</span>
                            <span style={{ fontSize: '12px', opacity: 0.9 }}>
                              {ally.special_role && ally.special_role !== ally.job
                                ? `${ally.special_role} - ${ally.job}`
                                : ally.job || 'Unknown'}
                            </span>
                          </>
                        )}
                      </Stack>
                    </Button>
                  ))}
                </Stack>
              ) : (
                <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '100%' }}>
                  <p style={{ color: '#7a2525ff' }}>YOU ARE ALONE</p>
                </div>
              )}
            </Section>
          </div>

        </div>
      </Stack.Item>

      <Section style={{ flex: 0, flexBasis: 'auto' }}>
        <Stack direction="row" justify="center">
          <Button
            onClick={() => act('view_laws')}
            style={{ flex: 1, fontSize: '25px', padding: '25px', display: 'flex', marginBottom: '110px', justifyContent: 'center', alignItems: 'center' }}
          >
            VIEW LAWS
          </Button>
          <Button
            onClick={() => act('view_decrees')}
            style={{ flex: 1, fontSize: '25px', padding: '25px', display: 'flex', marginBottom: '110px', justifyContent: 'center', alignItems: 'center' }}
          >
            VIEW DECREES
          </Button>
        </Stack>
      </Section>
    </Stack>
  );
};
