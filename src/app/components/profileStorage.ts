export interface StoredProfile {
  name: string;
  schoolLevel: string;
  school: string;
  subjects: string[];
  titleI: boolean;
}

const KEY_PREFIX = 'lfl_profile_';

export function loadProfile(email: string): StoredProfile | null {
  try {
    const raw = localStorage.getItem(KEY_PREFIX + email.trim().toLowerCase());
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}

export function saveProfile(email: string, profile: StoredProfile) {
  try {
    localStorage.setItem(KEY_PREFIX + email.trim().toLowerCase(), JSON.stringify(profile));
  } catch {
    // localStorage unavailable (e.g. private browsing) — profile just won't persist across sessions
  }
}

export function deriveNameFromEmail(email: string): string {
  const local = email.split('@')[0] || '';
  const words = local.split(/[._-]+/).filter(Boolean);
  if (words.length === 0) return 'Teacher';
  return words.map(w => w.charAt(0).toUpperCase() + w.slice(1)).join(' ');
}
