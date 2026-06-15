import { Bell, ChevronRight, X, Star, LogIn } from 'lucide-react';
import { useState } from 'react';
import { grants, Grant } from './grantData';
import { BottomNav, Tab } from './BottomNav';

const SUBJECT_FILTERS = ['STEM', 'Reading', 'Arts', 'Special Education', 'History'];
const LEVEL_FILTERS = ['Elementary', 'Middle School', 'High School', 'All Levels'];
const FUNDING_FILTERS = ['$0–$1k', '$1k–$3k', '$3k–$5k', '$5k+'];

interface Props {
  teacherName: string;
  schoolLevel: string;
  subjects: string[];
  onGrantSelect: (id: string) => void;
  onTeacherSpotlight: () => void;
  onAccountPress: () => void;
  activeTab: Tab;
  onTabChange: (tab: Tab) => void;
}

function MatchBadge({ pct }: { pct: number }) {
  return (
    <div
      className="flex flex-col items-center justify-center rounded-full flex-shrink-0"
      style={{ width: 48, height: 48, background: '#134F34' }}
    >
      <span style={{ color: '#fff', fontWeight: 700, fontSize: '13px', lineHeight: 1 }}>{pct}%</span>
      <span style={{ color: '#A7D9BC', fontSize: '8px', lineHeight: 1.2 }}>Match</span>
    </div>
  );
}

function TagPill({ label, special }: { label: string; special?: boolean }) {
  return (
    <span
      className="px-2.5 py-0.5 rounded-full"
      style={{
        fontSize: '11px',
        fontWeight: 500,
        background: special ? '#FFF3E0' : '#EBF6F0',
        color: special ? '#E65100' : '#1B7A50',
        border: special ? '1px solid #FFE0B2' : '1px solid #C8E6D4',
      }}
    >
      {label}
    </span>
  );
}

function GrantCard({ grant, onPress }: { grant: Grant; onPress: () => void }) {
  return (
    <button
      onClick={onPress}
      className="w-full text-left bg-white rounded-2xl p-4 transition-all active:scale-[0.99]"
      style={{ boxShadow: '0 1px 6px rgba(0,0,0,0.07)', border: '1px solid #F0F0F0' }}
    >
      <div className="flex items-start gap-3">
        <div className="flex-1 min-w-0">
          <p style={{ fontSize: '10px', fontWeight: 700, letterSpacing: '0.08em', color: '#1B7A50', marginBottom: '4px' }}>
            {grant.funder.toUpperCase()}
          </p>
          <h3 className="text-gray-900 mb-2" style={{ fontSize: '15px', fontWeight: 700, lineHeight: 1.3 }}>
            {grant.title}
          </h3>
          <div className="flex flex-wrap gap-1.5 mb-3">
            {grant.tags.map(t => <TagPill key={t} label={t} />)}
            {grant.specialTag && <TagPill label={grant.specialTag} special />}
          </div>
          <div className="flex items-center gap-4">
            <div>
              <p style={{ fontSize: '10px', color: '#9CA3AF', fontWeight: 500 }}>Funding Available</p>
              <p style={{ fontSize: '14px', color: '#111827', fontWeight: 700 }}>{grant.amount}</p>
            </div>
            <div>
              <p style={{ fontSize: '10px', color: '#9CA3AF', fontWeight: 500 }}>Deadline</p>
              <p style={{ fontSize: '14px', color: '#111827', fontWeight: 700 }}>{grant.deadline}</p>
            </div>
          </div>
        </div>
        <MatchBadge pct={grant.match} />
      </div>
    </button>
  );
}

type FilterKey = 'subject' | 'level' | 'funding';

export function Dashboard({ teacherName, onGrantSelect, onTeacherSpotlight, onAccountPress, activeTab, onTabChange }: Props) {
  const [activeFilters, setActiveFilters] = useState<Record<FilterKey, string>>({
    subject: '',
    level: '',
    funding: '',
  });
  const [filterOpen, setFilterOpen] = useState<FilterKey | null>(null);

  const firstName = teacherName.split(' ')[0] || 'Teacher';

  const visibleGrants = grants.filter(g => {
    const sf = activeFilters.subject;
    const lf = activeFilters.level;
    if (sf && !g.tags.some(t => t.toLowerCase().includes(sf.toLowerCase()))) return false;
    if (lf && !g.tags.some(t => t.toLowerCase().includes(lf.toLowerCase()))) return false;
    return true;
  });

  const clearFilter = (key: FilterKey) => setActiveFilters(f => ({ ...f, [key]: '' }));

  const filterLabels: { key: FilterKey; label: string; options: string[] }[] = [
    { key: 'subject', label: 'Subject', options: SUBJECT_FILTERS },
    { key: 'level', label: 'Level', options: LEVEL_FILTERS },
    { key: 'funding', label: 'Funding', options: FUNDING_FILTERS },
  ];

  return (
    <div className="flex flex-col h-full bg-gray-50">
      <div className="flex-1 overflow-y-auto pb-20">
        {/* Header */}
        <div className="bg-white px-5 pt-12 pb-5" style={{ borderBottom: '1px solid #F0F0F0' }}>
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-3">
              <div
                className="w-9 h-9 rounded-xl flex items-center justify-center"
                style={{ background: '#1B7A50' }}
              >
                <span style={{ color: '#fff', fontWeight: 800, fontSize: '17px', lineHeight: 1 }}>L</span>
              </div>
              <div>
                <p style={{ fontSize: '11px', fontWeight: 700, color: '#1B7A50', letterSpacing: '0.05em' }}>
                  Louder for Learning
                </p>
                <p style={{ fontSize: '10px', color: '#9CA3AF' }}>Grants for Underfunded Schools</p>
              </div>
            </div>
            <div className="flex items-center gap-2">
              <button className="relative p-1">
                <Bell size={20} color="#374151" strokeWidth={1.8} />
                <span
                  className="absolute top-0.5 right-0.5 w-2 h-2 rounded-full"
                  style={{ background: '#1B7A50' }}
                />
              </button>
              {/* Account / login button */}
              <button
                onClick={onAccountPress}
                className="flex items-center gap-1.5 px-3 py-1.5 rounded-full transition-all active:scale-[0.97]"
                style={{ background: '#EBF6F0', border: '1.5px solid #C8E6D4' }}
              >
                <LogIn size={14} color="#1B7A50" />
                <span style={{ fontSize: '12px', fontWeight: 600, color: '#1B7A50' }}>
                  {firstName}
                </span>
              </button>
            </div>
          </div>

          {/* Teacher profile */}
          <div className="mb-4">
            <p style={{ fontSize: '11px', fontWeight: 700, letterSpacing: '0.08em', color: '#9CA3AF' }}>
              TEACHER PROFILE
            </p>
            <h2 className="text-gray-900" style={{ fontWeight: 700, fontSize: '20px' }}>
              Welcome back, {firstName}!
            </h2>
            <div className="flex items-center gap-2 mt-0.5">
              <span style={{ fontSize: '13px', color: '#6B7280' }}>Oakridge Elementary School</span>
              <span
                className="px-2 py-0.5 rounded-full"
                style={{ fontSize: '10px', fontWeight: 600, background: '#FEF2F2', color: '#DC2626', border: '1px solid #FECACA' }}
              >
                Underfunded
              </span>
            </div>
          </div>

          {/* Custom grants banner */}
          <div
            className="flex items-center gap-3 p-3.5 rounded-xl"
            style={{ background: '#EBF6F0', border: '1px solid #C8E6D4' }}
          >
            <div className="w-8 h-8 rounded-lg flex items-center justify-center" style={{ background: '#1B7A50' }}>
              <Star size={15} color="#fff" fill="#fff" />
            </div>
            <div className="flex-1">
              <p style={{ fontSize: '13px', fontWeight: 600, color: '#134F34' }}>3 New Custom Grants Found</p>
              <p style={{ fontSize: '11px', color: '#4D9E72' }}>Based on your STEM & Special Ed preferences</p>
            </div>
            <ChevronRight size={16} color="#4D9E72" />
          </div>
        </div>

        {/* Filters */}
        <div className="px-5 py-4 bg-white mb-2" style={{ borderBottom: '1px solid #F0F0F0' }}>
          <div className="flex items-center justify-between mb-3">
            <p style={{ fontSize: '12px', fontWeight: 700, color: '#374151' }}>QUICK FILTERS</p>
            {Object.values(activeFilters).some(Boolean) && (
              <button
                onClick={() => setActiveFilters({ subject: '', level: '', funding: '' })}
                style={{ fontSize: '12px', color: '#1B7A50', fontWeight: 600 }}
              >
                Clear Filters
              </button>
            )}
          </div>
          <div className="flex gap-2 flex-wrap">
            {filterLabels.map(({ key, label, options }) => {
              const val = activeFilters[key];
              return (
                <div key={key} className="relative">
                  <button
                    onClick={() => setFilterOpen(filterOpen === key ? null : key)}
                    className="flex items-center gap-1.5 px-3 py-1.5 rounded-full transition-all"
                    style={{
                      border: `1.5px solid ${val ? '#1B7A50' : '#E5E7EB'}`,
                      background: val ? '#EBF6F0' : '#fff',
                      fontSize: '12px',
                      fontWeight: 500,
                      color: val ? '#1B7A50' : '#6B7280',
                    }}
                  >
                    {val ? (
                      <>
                        {label}: {val}
                        <span onClick={e => { e.stopPropagation(); clearFilter(key); }}>
                          <X size={11} />
                        </span>
                      </>
                    ) : (
                      `${label} ▾`
                    )}
                  </button>
                  {filterOpen === key && (
                    <div
                      className="absolute top-full left-0 mt-1 bg-white rounded-xl shadow-lg z-10 min-w-[140px]"
                      style={{ border: '1px solid #E5E7EB' }}
                    >
                      {options.map(opt => (
                        <button
                          key={opt}
                          onClick={() => { setActiveFilters(f => ({ ...f, [key]: opt })); setFilterOpen(null); }}
                          className="w-full text-left px-4 py-2.5 hover:bg-gray-50 transition-colors"
                          style={{ fontSize: '13px', color: '#374151' }}
                        >
                          {opt}
                        </button>
                      ))}
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </div>

        <div className="px-5 pt-3">
          <div className="flex items-center justify-between mb-3">
            <p style={{ fontSize: '13px', fontWeight: 700, color: '#374151' }}>RECOMMENDED FOR YOU</p>
            <button style={{ fontSize: '12px', color: '#1B7A50', fontWeight: 600 }}>See All</button>
          </div>

          <div className="flex flex-col gap-3 mb-6">
            {visibleGrants.length > 0 ? (
              visibleGrants.map(g => (
                <GrantCard key={g.id} grant={g} onPress={() => onGrantSelect(g.id)} />
              ))
            ) : (
              <div className="text-center py-12">
                <p style={{ fontSize: '15px', color: '#9CA3AF' }}>No grants match your filters.</p>
                <button
                  onClick={() => setActiveFilters({ subject: '', level: '', funding: '' })}
                  className="mt-2"
                  style={{ fontSize: '13px', color: '#1B7A50', fontWeight: 600 }}
                >
                  Clear all filters
                </button>
              </div>
            )}
          </div>

          {/* Teacher of the Month card */}
          <button
            onClick={onTeacherSpotlight}
            className="w-full rounded-2xl overflow-hidden mb-6 text-left transition-all active:scale-[0.99]"
            style={{ boxShadow: '0 2px 12px rgba(0,0,0,0.10)' }}
          >
            <div className="flex items-center gap-3 px-4 py-2" style={{ background: '#134F34' }}>
              <Star size={13} color="#F5C842" fill="#F5C842" />
              <p style={{ fontSize: '10px', fontWeight: 700, letterSpacing: '0.1em', color: '#A7D9BC' }}>
                TEACHER OF THE MONTH
              </p>
            </div>
            <div className="p-4 flex items-center gap-4" style={{ background: '#1B7A50' }}>
              <div
                className="w-14 h-14 rounded-full flex-shrink-0 flex items-center justify-center"
                style={{ background: '#134F34', border: '3px solid rgba(255,255,255,0.2)' }}
              >
                <span style={{ fontSize: '22px', fontWeight: 700, color: '#fff' }}>M</span>
              </div>
              <div className="flex-1 min-w-0">
                <p style={{ fontSize: '16px', fontWeight: 700, color: '#fff' }}>Maria Okonkwo</p>
                <p style={{ fontSize: '12px', color: '#A7D9BC' }}>7th Grade Science · Langston Hughes MS</p>
                <p style={{ fontSize: '11px', color: '#C8E6D4', marginTop: '4px', lineHeight: 1.4 }}>
                  "My students don't just need textbooks…"
                </p>
              </div>
              <ChevronRight size={18} color="rgba(255,255,255,0.6)" />
            </div>
          </button>
        </div>
      </div>

      <BottomNav activeTab={activeTab} onTabChange={onTabChange} />
    </div>
  );
}
