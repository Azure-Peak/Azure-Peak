export const cls = (...parts: (string | false | undefined | null)[]) =>
  parts.filter(Boolean).join(' ');

export const stripHtml = (html: string): string => {
  const div = document.createElement('div');
  div.innerHTML = html;
  return div.textContent || div.innerText || '';
};
