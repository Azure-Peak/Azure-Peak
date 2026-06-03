import { useState } from 'react';

import {
  BUTTON_BG,
  cardStyle,
  FONT_BODY,
  FONT_TITLE,
  INK,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  rulerStyle,
  SEAL_AMBER,
  SEAL_RED,
  sectionHeaderStyle,
  SERIF,
} from '../common/parchment';
import {
  POSTING_TIER_LISTING,
  POSTING_TIER_NOTICE,
  type Posting,
  type PostingTier,
  type TabProps,
} from './types';

const NAME_MAX = 50;
const ROLE_MAX = 50;
const TITLE_MAX = 50;
const BODY_MAX = 500;

const postingGridStyle: React.CSSProperties = {
  display: 'grid',
  gridTemplateColumns: '1fr 1fr',
  gap: 10,
  alignItems: 'start',
};

export const PostingsTab = ({ data, act }: TabProps) => {
  const [showForm, setShowForm] = useState(false);

  const listings = data.postings.filter(
    (p) => p.tier === POSTING_TIER_LISTING,
  );
  const notices = data.postings.filter((p) => p.tier === POSTING_TIER_NOTICE);

  return (
    <>
      <div style={{ textAlign: 'right', marginBottom: 8 }}>
        {!showForm ? (
          <button
            type="button"
            style={inkButtonStyle({})}
            onClick={() => setShowForm(true)}
          >
            Make a Posting
          </button>
        ) : (
          <button
            type="button"
            style={inkButtonStyle({})}
            onClick={() => setShowForm(false)}
          >
            Hide Form
          </button>
        )}
      </div>

      {showForm && (
        <PostingForm
          data={data}
          act={act}
          onClose={() => setShowForm(false)}
        />
      )}

      <div style={sectionHeaderStyle}>Standing Listings</div>
      {listings.length === 0 ? (
        <EmptyMessage text="No standing listings have been pinned." />
      ) : (
        <div style={postingGridStyle}>
          {listings.map((p) => (
            <PostingCard key={p.posting_id} posting={p} act={act} />
          ))}
        </div>
      )}

      <hr style={rulerStyle} />

      <div style={sectionHeaderStyle}>Notices</div>
      {notices.length === 0 ? (
        <EmptyMessage text="No notices on the board. The wind stirs the empty parchments." />
      ) : (
        <div style={postingGridStyle}>
          {notices.map((p) => (
            <PostingCard key={p.posting_id} posting={p} act={act} />
          ))}
        </div>
      )}
    </>
  );
};

const EmptyMessage = ({ text }: { text: string }) => (
  <div
    style={{
      color: INK_FAINT,
      textAlign: 'center',
      padding: '12px 0',
    }}
  >
    {text}
  </div>
);

const PostingCard = ({
  posting,
  act,
}: {
  posting: Posting;
  act: TabProps['act'];
}) => {
  const isListing = posting.tier === POSTING_TIER_LISTING;
  return (
    <div
      style={{
        ...cardStyle,
        marginBottom: 0,
        background: isListing
          ? 'rgba(200,170,100,0.18)'
          : 'var(--p-card-bg)',
        borderColor: isListing ? INK_SOFT : INK_FAINT,
      }}
    >
      <div style={{ display: 'flex', alignItems: 'baseline' }}>
        <div
          style={{
            flex: 1,
            fontSize: FONT_TITLE,
            fontWeight: 'bold',
            color: INK,
            fontFamily: SERIF,
          }}
        >
          {posting.title}
        </div>
        <div
          style={{
            color: INK_FAINT,
            fontSize: FONT_BODY,
          }}
        >
          {posting.posted_at_label}
          {posting.expires_in_label && ` · expires ${posting.expires_in_label}`}
        </div>
      </div>

      {isListing && (
        <div
          style={{
            color: SEAL_AMBER,
            fontSize: FONT_BODY,
            marginTop: '2px',
          }}
        >
          Standing Listing
        </div>
      )}

      <div
        style={{
          marginTop: '6px',
          marginBottom: '6px',
          whiteSpace: 'pre-wrap',
          color: INK,
        }}
      >
        {posting.body}
      </div>

      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          marginTop: '6px',
        }}
      >
        <div
          style={{
            flex: 1,
            color: INK_SOFT,
            fontStyle: 'italic',
            fontSize: FONT_BODY,
          }}
        >
          - {posting.poster_name}
          {posting.poster_title && `, ${posting.poster_title}`}
          {!posting.signature_attested && (
            <span
              style={{
                color: INK_FAINT,
                fontSize: FONT_BODY,
                marginLeft: '6px',
              }}
            >
              (unattested, yet)
            </span>
          )}
        </div>
        {!!posting.is_own && (
          <button
            type="button"
            style={inkButtonStyle({})}
            onClick={() => act('remove_post', { posting_id: posting.posting_id })}
          >
            Take Down
          </button>
        )}
        {!posting.is_own && !!posting.can_authority_remove && (
          <button
            type="button"
            style={inkButtonStyle({})}
            onClick={() =>
              act('authority_remove_post', { posting_id: posting.posting_id })
            }
          >
            Remove (Authority)
          </button>
        )}
      </div>
    </div>
  );
};

const PostingForm = ({
  data,
  act,
  onClose,
}: TabProps & { onClose: () => void }) => {
  const [tier, setTier] = useState<PostingTier>(POSTING_TIER_NOTICE);
  const [title, setTitle] = useState('');
  const [body, setBody] = useState('');
  const [posterName, setPosterName] = useState(data.user_default_name || '');
  const [posterTitle, setPosterTitle] = useState(data.user_default_role || '');

  const titleValid = title.length > 0 && title.length <= TITLE_MAX;
  const bodyValid = body.length > 0 && body.length <= BODY_MAX;
  const nameValid = posterName.length > 0 && posterName.length <= NAME_MAX;
  const roleValid = posterTitle.length <= ROLE_MAX;
  const valid = titleValid && bodyValid && nameValid && roleValid;

  const willReplaceNotice =
    tier === POSTING_TIER_NOTICE && !!data.has_active_notice;
  const willReplaceListing =
    tier === POSTING_TIER_LISTING && !!data.has_active_listing;

  const onPost = () => {
    if (!valid) {
      return;
    }
    if (willReplaceListing) {
      const ok = confirm(
        'You already have a Standing Listing posted. Posting a new one will replace it. Proceed?',
      );
      if (!ok) {
        return;
      }
    }
    act('make_post', {
      tier,
      title,
      body,
      poster_name: posterName,
      poster_title: posterTitle,
    });
    onClose();
  };

  return (
    <div
      style={{
        ...cardStyle,
        background: BUTTON_BG,
        borderColor: INK_SOFT,
      }}
    >
      <div style={sectionHeaderStyle}>Pin a Posting</div>

      {!!data.can_post_listing && (
        <div style={{ marginBottom: 10 }}>
          <div style={fieldLabel}>Kind of posting</div>
          <div style={{ display: 'flex', gap: 8, marginTop: 4 }}>
            <button
              type="button"
              style={{
                ...inkButtonStyle({}),
                fontWeight: tier === POSTING_TIER_NOTICE ? 'bold' : 'normal',
                background:
                  tier === POSTING_TIER_NOTICE
                    ? 'var(--p-tab-active-bg)'
                    : BUTTON_BG,
              }}
              onClick={() => setTier(POSTING_TIER_NOTICE)}
            >
              Notice (expires in 30m)
            </button>
            <button
              type="button"
              style={{
                ...inkButtonStyle({}),
                fontWeight: tier === POSTING_TIER_LISTING ? 'bold' : 'normal',
                background:
                  tier === POSTING_TIER_LISTING
                    ? 'var(--p-tab-active-bg)'
                    : BUTTON_BG,
              }}
              onClick={() => setTier(POSTING_TIER_LISTING)}
            >
              Standing Listing (no expiry)
            </button>
          </div>
        </div>
      )}

      <FormField
        label="Title"
        value={title}
        onChange={setTitle}
        max={TITLE_MAX}
      />
      <FormField
        label="Body"
        value={body}
        onChange={setBody}
        max={BODY_MAX}
        multiline
      />
      <FormField
        label="Signed as"
        value={posterName}
        onChange={setPosterName}
        max={NAME_MAX}
      />
      <FormField
        label="Title or role"
        value={posterTitle}
        onChange={setPosterTitle}
        max={ROLE_MAX}
        optional
      />

      {willReplaceNotice && (
        <div
          style={{
            color: SEAL_AMBER,
            fontSize: FONT_BODY,
            marginTop: 6,
          }}
        >
          You have a Notice already posted. Pinning this will take it down.
        </div>
      )}
      {willReplaceListing && (
        <div
          style={{
            color: SEAL_AMBER,
            fontSize: FONT_BODY,
            marginTop: 6,
          }}
        >
          You have a Standing Listing already posted. Pinning this will take it down.
        </div>
      )}

      <div
        style={{
          display: 'flex',
          justifyContent: 'flex-end',
          gap: 6,
          marginTop: 10,
        }}
      >
        <button type="button" style={inkButtonStyle({})} onClick={onClose}>
          Cancel
        </button>
        <button
          type="button"
          style={inkButtonStyle({ disabled: !valid })}
          disabled={!valid}
          onClick={onPost}
        >
          Pin Posting
        </button>
      </div>
    </div>
  );
};

const fieldLabel = {
  color: SEAL_AMBER,
  fontSize: FONT_BODY,
};

const FormField = ({
  label,
  value,
  onChange,
  max,
  multiline,
  optional,
}: {
  label: string;
  value: string;
  onChange: (v: string) => void;
  max: number;
  multiline?: boolean;
  optional?: boolean;
}) => {
  const overLimit = value.length > max;
  return (
    <div style={{ marginBottom: 8 }}>
      <div style={{ display: 'flex', alignItems: 'baseline' }}>
        <div style={{ ...fieldLabel, flex: 1 }}>
          {label}
          {optional && (
            <span style={{ color: INK_FAINT, marginLeft: 4 }}>(optional)</span>
          )}
        </div>
        <div
          style={{
            color: overLimit ? SEAL_RED : INK_FAINT,
            fontSize: FONT_BODY,
          }}
        >
          {value.length} / {max}
        </div>
      </div>
      {multiline ? (
        <textarea
          value={value}
          onChange={(e) => onChange(e.target.value)}
          rows={5}
          style={{
            width: '100%',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            background: BUTTON_BG,
            border: `1px solid ${INK_FAINT}`,
            color: INK,
            padding: '4px 6px',
            resize: 'vertical',
          }}
        />
      ) : (
        <input
          type="text"
          value={value}
          onChange={(e) => onChange(e.target.value)}
          style={{
            width: '100%',
            fontFamily: SERIF,
            fontSize: FONT_BODY,
            background: BUTTON_BG,
            border: `1px solid ${INK_FAINT}`,
            color: INK,
            padding: '3px 6px',
          }}
        />
      )}
    </div>
  );
};
