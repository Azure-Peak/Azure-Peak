import { Button, Section, Stack } from 'tgui-core/components';

import { NobleType } from './WarbandTypes';

type WorldTabProps = {
  nobleList: NobleType[];
  alliesList: NobleType[];
  act: (action: string, payload?: object) => void;
};

export const WorldTab = ({ nobleList, alliesList, act }: WorldTabProps) => {
  return (
    <Stack vertical fill>
      <Stack direction="row" fill style={{ flex: 1 }}>
        <Section title={<span style={{ color: '#7a2525ff' }}>KNOW THY ENEMIES</span>} scrollable fill style={{ flex: 1, minWidth: '300px' }}>
          {nobleList.length > 0 ? (
            <Stack vertical>
              {nobleList.map((noble) => (
                <Button
                  key={noble.name}
                  tooltip={noble.name}
                  onClick={() => {
                    act('interaction_sound');
                    act('view_vip', { enemy: noble.name });
                  }}
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

        <Section title={<span style={{ color: '#7a2525ff' }}>KNOW THY FRIENDS</span>} scrollable fill style={{ flex: 1, minWidth: '300px' }}>
          {alliesList.length > 0 ? (
            <Stack vertical>
              {alliesList.map((ally, index) => (
                <Button
                  key={`${ally.name}-${index}`}
                  tooltip={ally.name}
                  onClick={() => {
                    act('interaction_sound');
                    if (!ally.in_lobby) {
                      act('view_vip', { ally: ally.name });
                    }
                  }}
                  disabled={ally.in_lobby}
                  style={{ 
                    textAlign: 'left',
                    opacity: ally.in_lobby ? 0.7 : 1,
                  }}
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
      </Stack>

      <Section style={{ flex: 0.3 }}>
        <Stack direction="row" justify="center">
          <Button 
            onClick={() => act('view_laws')}
            style={{
              flex: 1,              
              fontSize: '25px',
              padding: '25px',
              display: 'flex',
              marginBottom: '90px',
              justifyContent: 'center',
              alignItems: 'center',
            }}
          >
            VIEW LAWS
          </Button>
          <Button 
            onClick={() => act('view_decrees')}
            style={{
              flex: 1,              
              fontSize: '25px',
              padding: '25px',
              display: 'flex',
              marginBottom: '90px',
              justifyContent: 'center',
              alignItems: 'center',
            }}
          >
            VIEW DECREES
          </Button>
        </Stack>
      </Section>
    </Stack>
  );
};
