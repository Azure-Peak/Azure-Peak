export function validateRegExp(str: string): any {
  try {
    new RegExp(str);
    return true;
  } catch (e) {
    return e;
  }
}
