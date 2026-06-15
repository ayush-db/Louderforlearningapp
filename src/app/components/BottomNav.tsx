import { Search, FileEdit, CheckCircle2, UserCircle } from 'lucide-react';

export type Tab = 'grants' | 'apply' | 'status' | 'account';

interface BottomNavProps {
  activeTab: Tab;
  onTabChange: (tab: Tab) => void;
}

const tabs = [
  { id: 'grants' as Tab, label: 'Grants', Icon: Search },
  { id: 'apply' as Tab, label: 'Apply', Icon: FileEdit },
  { id: 'status' as Tab, label: 'My Status', Icon: CheckCircle2 },
  { id: 'account' as Tab, label: 'My Account', Icon: UserCircle },
];

export function BottomNav({ activeTab, onTabChange }: BottomNavProps) {
  return (
    <div
      className="absolute bottom-0 left-0 right-0 flex bg-white z-50"
      style={{ borderTop: '1px solid #F0F0F0' }}
    >
      {tabs.map(({ id, label, Icon }) => {
        const active = activeTab === id;
        return (
          <button
            key={id}
            onClick={() => onTabChange(id)}
            className="flex-1 flex flex-col items-center py-3 gap-0.5 transition-colors active:bg-gray-50"
          >
            <Icon
              size={21}
              strokeWidth={active ? 2.5 : 1.8}
              color={active ? '#1B7A50' : '#9CA3AF'}
            />
            <span
              style={{
                fontSize: '10px',
                fontWeight: active ? 600 : 400,
                color: active ? '#1B7A50' : '#9CA3AF',
                lineHeight: 1,
              }}
            >
              {label}
            </span>
          </button>
        );
      })}
    </div>
  );
}
