import { useState } from 'react';

import {
  fieldLabelStyle,
  fieldRowStyle,
  fieldValueStyle,
  FONT_BODY,
  INK_FAINT,
  inkButtonStyle,
  SEAL_AMBER,
  SEAL_GREEN,
  SEAL_RED,
  sectionHeaderStyle,
} from '../../common/parchment';
import { type TabProps } from '../types';

const formatCooldown = (seconds: number) => {
  const minutes = Math.ceil(seconds / 60);
  return `${minutes} minute${minutes === 1 ? '' : 's'}`;
};

export const BathhouseOrdinanceSection = ({
  data,
  act,
}: {
  data: TabProps['data'];
  act: TabProps['act'];
}) => {
  const active = !!data.bathhouse_ordinance_active;
  const tithed = data.bathhouse_tithe_round_total ?? 0;
  const cooldownSeconds = data.bathhouse_ordinance_cooldown_seconds ?? 0;
  const onCooldown = cooldownSeconds > 0;
  const [confirming, setConfirming] = useState(false);
  const [expanded, setExpanded] = useState(false);

  const primaryLabel = active ? 'Break the Ordinance' : 'Restore the Ordinance';
  const confirmLabel = active
    ? 'Confirm: Break the Ordinance'
    : 'Confirm: Restore the Ordinance';

  return (
    <>
      <div style={sectionHeaderStyle}>Ordinance of the Baths</div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Status</div>
        <div style={fieldValueStyle}>
          {active ? (
            <span style={{ color: SEAL_GREEN, fontWeight: 'bold' }}>
              IN FORCE
            </span>
          ) : (
            <span style={{ color: SEAL_RED, fontWeight: 'bold' }}>
              BROKEN
            </span>
          )}
        </div>
      </div>
      <div style={fieldRowStyle}>
        <div style={fieldLabelStyle}>Tithe this week</div>
        <div style={fieldValueStyle}>
          <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
            {tithed}m
          </span>{' '}
          rendered unto the Church.
        </div>
      </div>
      <div style={{ marginBottom: 8 }}>
        <button
          type="button"
          style={{
            ...inkButtonStyle({}),
            fontSize: FONT_BODY,
            padding: '2px 6px',
          }}
          onClick={() => setExpanded((v) => !v)}
        >
          {expanded ? 'Hide the Ordinance ▴' : 'Read the Ordinance ▾'}
        </button>
        {expanded && (
          <div
            style={{
              color: SEAL_AMBER,
              marginTop: 6,
              fontSize: FONT_BODY,
              lineHeight: 1.4,
            }}
          >
            <p style={{ margin: '0 0 6px 0' }}>
              {
                'By ancient prerogative granted of the Crown, the Baths of Azure Peak stand within the Bishop\'s liberty. The Bathmaster oweth no farm nor fee unto the Crown\'s coffers; rather, of all sales of herbs and unguents, the Bathmaster shall render one part in ten, and of the regular income arising from the rendering of services, one part in five, unto the Church. The Baths shall stand as a hearth unto Eora\'s flames, to render comfort and solace unto the lonely and the weary who enters, to give those who freely love and renders it unto others a safe place of working such that they may make their keep, and count the Baths labor amongst the goddess\'s own works, pleasing to her sight. And thus the Church doth take the Baths into its protection, by blade and by law. So long as the Ordinance holds, the Crown shall have no claim upon the Baths, whose most holy works is within the Church\'s sole jurisdiction.'
              }
            </p>
            <p style={{ margin: '0 0 4px 0' }}>
              {
                'The Bathmaster, in turn, doth undertake the orderly provision of comfort unto the lonely and the weary; and shall keep the following ordinances:'
              }
            </p>
            <ul style={{ margin: '0 0 6px 16px', padding: 0 }}>
              <li style={{ marginBottom: 4 }}>
                {
                  'To prohibit the sale or trafficking of any physick or smoke stronger than purified moondust and ozium, lest the mind of any guest be so clouded as to forget the Ten\'s teaching. Violation shall be fined a zilaque.'
                }
              </li>
              <li style={{ marginBottom: 4 }}>
                {
                  'To give no shelter to thieves nor fugitives, neither within the stews nor beneath them. Violation shall be fined a zenny, and the ill-gotten goods rendered unto the Church for remedy.'
                }
              </li>
              <li style={{ marginBottom: 4 }}>
                {
                  'To suffer within the Baths no manifest scandal of false devotion. Of any attendant or guest who hath lost themselves to wanton hedonism or to the depravities of false rites, the Bathmaster shall inform the Church in manner most discreet, and deliver such soul unto the Church\'s care - that they may be shown again the light of Eora\'s love. So long as none is harmed, what is done behind closed doors the Ordinance shall not intrude upon; for Eora hath granted unto her faithful the gift of love and intimacy in privacy, as is pleasing to her sight.'
                }
              </li>
              <li style={{ marginBottom: 4 }}>
                {
                  'To turn no soul away for want of coin who beareth the wounds of soldiery or the marks of pilgrimage, but to grant unto them the public bath without charge, once in the week. Failing this charity, the Bathmaster shall be fined a zenny, rendered unto the alms of the Church.'
                }
              </li>
              <li style={{ marginBottom: 4 }}>
                {
                  'To render unto no drunken soul more liquor than they can hold; to serve no guest more than five sniffings of unguents in a single sitting; and to suffer no soul to take more of any physick than the body may bear, lest they fall into convulsion, delirium, or Necra\'s embrace before their time is due. The Bathmaster shall be answerable for any guest who is borne forth in such a state, and shall render unto the kin of the lost, or the Church which must undertake their resuscitation, a recompense as the Church shall judge fit.'
                }
              </li>
            </ul>
            <p style={{ margin: '0 0 6px 0' }}>
              {
                'Should the ordinances be broken, the Church may renounce its sanction or seek recompense as it see fit; the brassface shall fall again beneath the Crown\'s tariff, and the matter of the Baths\' regular income shall be settled thereafter between the Bathmaster and the Crown alone.'
              }
            </p>
            <p style={{ margin: 0, color: INK_FAINT }}>
              {
                'The Bishop and the Bathmaster each hold the seal. Either may break or restore the Ordinance; neither may do so twice in quick succession.'
              }
            </p>
          </div>
        )}
      </div>
      {onCooldown && (
        <div
          style={{
            color: INK_FAINT,
            marginBottom: 8,
            fontSize: FONT_BODY,
          }}
        >
          The seal is still warm upon the wax. The Ordinance may be reconsidered in{' '}
          {formatCooldown(cooldownSeconds)}.
        </div>
      )}
      <div
        style={{
          marginTop: 6,
          textAlign: 'right',
          display: 'flex',
          justifyContent: 'flex-end',
          gap: 6,
        }}
      >
        {confirming && (
          <button
            type="button"
            style={inkButtonStyle({})}
            onClick={() => setConfirming(false)}
          >
            Cancel
          </button>
        )}
        <button
          type="button"
          style={inkButtonStyle({ disabled: onCooldown })}
          disabled={onCooldown}
          onClick={() => {
            if (!confirming) {
              setConfirming(true);
              return;
            }
            act('toggle_bathhouse_ordinance');
            setConfirming(false);
          }}
        >
          {confirming ? confirmLabel : primaryLabel}
        </button>
      </div>
    </>
  );
};
