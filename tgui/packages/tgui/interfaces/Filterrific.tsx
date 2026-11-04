import type {
  ColorMatrix,
  FilterDefaults,
  FilterInfo,
  FilterProps,
  FilterType,
  MasterFilterInfo,
  TransformMatrix,
} from 'common/byond_types';
import { typedKeys } from 'common/type-safety';
import { map } from 'es-toolkit/compat';
import { useState } from 'react';
import {
  Box,
  Button,
  Collapsible,
  ColorBox,
  Dropdown,
  Input,
  LabeledList,
  NoticeBox,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';
import { numberOfDecimalDigits, toFixed } from 'tgui-core/math';
import { useBackend, useBackendStrict } from '../backend';
import { Window } from '../layouts';

function getFilterValues<K extends FilterType>(
  filterDefaults: MasterFilterInfo,
  type: K,
  filterProps: Partial<FilterProps<K>>,
) {
  const defaults = filterDefaults[type].defaults as FilterDefaults<K>;
  const targetFilterPossibleKeys = typedKeys(defaults);

  return targetFilterPossibleKeys.map((name) => {
    const value = filterProps[name] ?? defaults[name];
    const hasValue = value !== defaults[name];

    return {
      name,
      value,
      hasValue,
    };
  });
}

const FilterIntegerEntry = (props: {
  value: number;
  name: string;
  filterName: string;
}) => {
  const { value, name, filterName } = props;
  const { act } = useBackend();
  return (
    <NumberInput
      value={value || 0}
      minValue={-500}
      maxValue={500}
      step={1}
      stepPixelSize={5}
      width="39px"
      onChange={(value) =>
        act('modify_filter_value', {
          name: filterName,
          new_data: {
            [name]: value,
          },
        })
      }
    />
  );
};

const FilterFloatEntry = (props: {
  value: number;
  name: string;
  filterName: string;
}) => {
  const { value, name, filterName } = props;
  const { act } = useBackend();
  const [step, setStep] = useState(0.01);

  return (
    <>
      <NumberInput
        value={value || 0}
        minValue={-500}
        maxValue={500}
        stepPixelSize={4}
        step={step}
        format={(value) => toFixed(value, numberOfDecimalDigits(step))}
        width="80px"
        onChange={(value) =>
          act('transition_filter_value', {
            name: filterName,
            new_data: {
              [name]: value,
            },
          })
        }
      />
      <Box inline ml={2} mr={1}>
        Step:
      </Box>
      <NumberInput
        value={step}
        step={0.001}
        format={(value) => toFixed(value, 4)}
        width="70px"
        onChange={(value) => setStep(value)}
      />
    </>
  );
};

const FilterTextEntry = (props: {
  value: string;
  name: string;
  filterName: string;
}) => {
  const { value, name, filterName } = props;
  const { act } = useBackend();

  return (
    <Input
      value={value}
      width="250px"
      onBlur={(value) =>
        act('modify_filter_value', {
          name: filterName,
          new_data: {
            [name]: value,
          },
        })
      }
    />
  );
};

const FilterColorEntry = (props: {
  value: string;
  filterName: string;
  name: string;
}) => {
  const { value, filterName, name } = props;
  const { act } = useBackend();
  return (
    <>
      <Button
        icon="pencil-alt"
        onClick={() =>
          act('modify_color_value', {
            name: filterName,
          })
        }
      />
      <ColorBox color={value} mr={0.5} />
      <Input
        value={value}
        width="90px"
        onBlur={(value) =>
          act('transition_filter_value', {
            name: filterName,
            new_data: {
              [name]: value,
            },
          })
        }
      />
    </>
  );
};

const FilterIconEntry = (props: { value: string; filterName: string }) => {
  const { value, filterName } = props;
  const { act } = useBackend();
  return (
    <>
      <Button
        icon="pencil-alt"
        onClick={() =>
          act('modify_icon_value', {
            name: filterName,
          })
        }
      />
      <Box inline ml={1}>
        {value}
      </Box>
    </>
  );
};

const FilterFlagsEntry = (props: {
  name: string;
  value: number;
  filterName: string;
  filterType: FilterType;
}) => {
  const { name, value, filterName, filterType } = props;
  const { act, data } = useBackend<Data>();

  const filterInfo = data.filter_info;
  const flags = filterInfo[filterType].flags;
  return map(flags, (bitField, flagName) => (
    <Button.Checkbox
      checked={value & bitField}
      onClick={() =>
        act('modify_filter_value', {
          name: filterName,
          new_data: {
            [name]: value ^ bitField,
          },
        })
      }
      key={flagName}
    >
      {flagName}
    </Button.Checkbox>
  ));
};

const FilterOptionsEntry = (props: {
  name: string;
  value: any;
  filterName: string;
  filterType: FilterType;
}) => {
  const { name, value, filterName, filterType } = props;
  const { act, data } = useBackend();
  const filterInfo = data.filter_info;
  const options = filterInfo[filterType].options[name];
  return (
    <Dropdown
      selected={Object.keys(options).find((x) => value === options[x])}
      options={Object.keys(options)}
      onSelected={(value) =>
        act('modify_filter_value', {
          name: filterName,
          new_data: {
            [name]: options[value],
          },
        })
      }
    />
  );
};

const FilterTransformEntry = (props: {
  value: TransformMatrix;
  name: string;
  filterName: string;
}) => {
  const { value, name, filterName } = props;
  const { act } = useBackend();

  return (
    <>
      <Stack>
        {['a', 'b', 'c'].map((letter_key) => (
          <Stack.Item key={letter_key}>
            <Box inline ml={2} mr={1}>
              {letter_key}:
            </Box>
            <NumberInput
              value={
                value ? value[letter_key as keyof TransformMatrix] || 0 : 0
              }
              minValue={letter_key === 'c' ? -480 : -4}
              maxValue={letter_key === 'c' ? 480 : 4}
              step={letter_key === 'c' ? 1 : 0.01}
              stepPixelSize={5}
              width="39px"
              onChange={(value) =>
                act('modify_transform_value', {
                  name: filterName,
                  field_name: name,
                  transform_key: letter_key,
                  transform_value: value,
                })
              }
            />
          </Stack.Item>
        ))}
      </Stack>
      <Stack>
        {['d', 'e', 'f'].map((letter_key) => (
          <Stack.Item key={letter_key}>
            <Box inline ml={2} mr={1}>
              {letter_key}:
            </Box>
            <NumberInput
              value={
                value ? value[letter_key as keyof TransformMatrix] || 0 : 0
              }
              minValue={letter_key === 'f' ? -480 : -4}
              maxValue={letter_key === 'f' ? 480 : 4}
              step={letter_key === 'f' ? 1 : 0.01}
              stepPixelSize={5}
              width="39px"
              onChange={(value) =>
                act('modify_transform_value', {
                  name: filterName,
                  field_name: name,
                  transform_key: letter_key,
                  transform_value: value,
                })
              }
            />
          </Stack.Item>
        ))}
      </Stack>
    </>
  );
};

const FilterMatrixEntry = (props: {
  name: string;
  value: ColorMatrix;
  filterName: string;
}) => {
  const { name, value, filterName } = props;
  const { act } = useBackend();
  const matrix_sizes = [9, 12, 16, 20];
  const resize_matrix = (matrix: ColorMatrix, size: number): ColorMatrix => {
    let identity = [1, 0, 0, 0, 1, 0, 0, 0, 1];
    switch (size) {
      case 12:
        identity = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0];
        break;
      case 16:
        identity = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
        break;
      case 20:
        identity = [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0];
        break;
    }
    if (
      matrix === null ||
      matrix === undefined ||
      // we don't support list(rgb()) format
      typeof matrix[0] === 'object'
    ) {
      return identity as ColorMatrix;
    }

    for (let i = 0; i < Math.min(size, matrix.length); i++) {
      if (matrix.length === 9) {
        identity[i + Math.floor(i / 3)] = matrix[i] as number; // Account for skipped constants
      } else {
        identity[i] = matrix[i] as number;
      }
    }

    return identity as ColorMatrix;
  };

  let matrix = value;

  if (value === null || value === undefined) {
    matrix = resize_matrix(value, 9);
  }

  const processed_matrix = [];
  const row_width = matrix.length > 9 ? 4 : 3;
  for (let i = 0; i < (matrix.length > 9 ? matrix.length / 4 : 3); i++) {
    const new_row = [];
    for (let j = 0; j < row_width; j++) {
      new_row.push(matrix[i * row_width + j]);
    }
    processed_matrix.push(new_row);
  }

  return (
    <Box>
      <Dropdown
        displayText="Matrix Size"
        selected={`${matrix.length} elements`}
        options={matrix_sizes.map((size) => `${size} elements`)}
        onSelected={(option) =>
          matrix.length === parseInt(option.split(' '), 10)
            ? null
            : act('modify_filter_value', {
                name: filterName,
                new_data: {
                  [name]: resize_matrix(
                    matrix,
                    parseInt(option.split(' '), 10),
                  ),
                },
              })
        }
      />
      <Stack vertical>
        {processed_matrix.map((matrix_row, row_index) => (
          <Stack.Item key={row_index}>
            <Stack>
              {matrix_row.map((matrix_elem, elem_index) => (
                <Stack.Item key={elem_index}>
                  <NumberInput
                    value={
                      (matrix[row_index * row_width + elem_index] as number) ||
                      0
                    }
                    minValue={-4}
                    maxValue={4}
                    step={0.01}
                    stepPixelSize={5}
                    width="39px"
                    onChange={(value) => {
                      matrix[row_index * row_width + elem_index] = value;
                      act('transition_filter_value', {
                        name: filterName,
                        new_data: {
                          [name]: matrix,
                        },
                      });
                    }}
                  />
                </Stack.Item>
              ))}
            </Stack>
          </Stack.Item>
        ))}
      </Stack>
    </Box>
  );
};

const FilterDataEntry = (props: any) => {
  const { name, hasValue, filterType } = props;

  const filterEntryTypes = {
    int: <FilterIntegerEntry {...props} />,
    float: <FilterFloatEntry {...props} />,
    string: <FilterTextEntry {...props} />,
    color: <FilterColorEntry {...props} />,
    icon: <FilterIconEntry {...props} />,
    flags: <FilterFlagsEntry {...props} />,
    options: <FilterOptionsEntry {...props} />,
    transform: <FilterTransformEntry {...props} />,
    matrix: <FilterMatrixEntry {...props} />,
    plug: 'Not Implemented',
  };

  const filterEntryMap = {
    x: 'float',
    y: 'float',
    icon: 'icon',
    render_source: 'string',
    flags: 'flags',
    size: 'float',
    color: { default: 'color', color: 'matrix' },
    offset: 'float',
    radius: 'int',
    falloff: 'float',
    density: 'int',
    alpha: 'int',
    threshold: { rays: 'float', bloom: 'color' },
    factor: 'float',
    repeat: 'int',
    space: 'options',
    blend_mode: 'options',
    transform: 'transform',
  };

  let filterInputType: any =
    filterEntryMap[name as keyof typeof filterEntryMap];
  // i hate javascript, this checks if its a dict
  if (filterInputType !== undefined && filterInputType.constructor === Object) {
    filterInputType = filterInputType[filterType] || filterInputType.default;
  }

  return (
    <LabeledList.Item label={name}>
      <Box inline>
        {filterEntryTypes[filterInputType as keyof typeof filterEntryTypes] ||
          'Not Found (This is an error)'}{' '}
      </Box>
      {!hasValue && (
        <Box inline color="average">
          (Default)
        </Box>
      )}
    </LabeledList.Item>
  );
};

const FilterEntry = (props: { name: string; filterDataEntry: FilterInfo }) => {
  const { act, data } = useBackend<Data>();
  const { name, filterDataEntry } = props;
  const { type, priority, ...restOfProps } = filterDataEntry;

  const filterValues = getFilterValues(
    data.filter_info,
    filterDataEntry.type,
    restOfProps,
  );

  return (
    <Collapsible
      title={`${name} (${type})`}
      buttons={
        <>
          <NumberInput
            value={priority}
            step={1}
            stepPixelSize={10}
            width="60px"
            onChange={(value) =>
              act('change_priority', {
                name: name,
                new_priority: value,
              })
            }
          />
          <Button.Input
            buttonText="Rename"
            onCommit={(value) =>
              act('rename_filter', {
                name,
                new_name: value,
              })
            }
            width="90px"
          />
          <Button.Confirm
            icon="minus"
            onClick={() => act('remove_filter', { name: name })}
          />
        </>
      }
    >
      <Section>
        <LabeledList>
          {filterValues.map((entry) => {
            return (
              <FilterDataEntry
                key={entry.name}
                filterName={name}
                filterType={type}
                name={entry.name}
                value={entry.value}
                hasValue={entry.hasValue}
              />
            );
          })}
        </LabeledList>
      </Section>
    </Collapsible>
  );
};

type Data = {
  filter_info: MasterFilterInfo;
  target_name: string;
  target_filter_data: FilterInfo[];
};

export const Filterrific = () => {
  const { act, data } = useBackendStrict<Data>();
  const name = data.target_name || 'Unknown Object';
  const filters = data.target_filter_data || {};
  const hasFilters = Object.keys(filters).length !== 0;
  const filterDefaults = data.filter_info;
  const [massApplyPath, setMassApplyPath] = useState('');
  const [hiddenSecret, setHiddenSecret] = useState(false);

  return (
    <Window title="Filterrific" width={500} height={500}>
      <Window.Content scrollable>
        <NoticeBox danger>
          DO NOT MESS WITH EXISTING FILTERS IF YOU DO NOT KNOW THE CONSEQUENCES.
          YOU HAVE BEEN WARNED.
        </NoticeBox>
        <Section
          title={
            hiddenSecret ? (
              <>
                <Box mr={0.5} inline>
                  MASS EDIT:
                </Box>
                <Input
                  value={massApplyPath}
                  width="100px"
                  onChange={setMassApplyPath}
                />
                <Button.Confirm
                  content="Apply"
                  confirmContent="ARE YOU SURE?"
                  onClick={() => act('mass_apply', { path: massApplyPath })}
                />
              </>
            ) : (
              <Box inline onDoubleClick={() => setHiddenSecret(true)}>
                {name}
              </Box>
            )
          }
          buttons={
            <Dropdown
              icon="plus"
              displayText="Add Filter"
              noChevron
              options={Object.keys(filterDefaults)}
              selected={null}
              onSelected={(value) =>
                act('add_filter', {
                  name: 'default',
                  priority: 10,
                  type: value,
                })
              }
            />
          }
        >
          {!hasFilters ? (
            <Box>No filters</Box>
          ) : (
            map(filters, (entry, key) => (
              <FilterEntry
                filterDataEntry={entry}
                name={entry.name}
                key={entry.name}
              />
            ))
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
