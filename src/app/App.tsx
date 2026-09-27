import { useState } from 'react';
import { LoginScreen } from './components/LoginScreen';
import { OnboardingStep1 } from './components/OnboardingStep1';
import { OnboardingStep2 } from './components/OnboardingStep2';
import { Dashboard } from './components/Dashboard';
import { GrantDetails } from './components/GrantDetails';
import { ApplicationForm } from './components/ApplicationForm';
import { ApplicationStatus } from './components/ApplicationStatus';
import { TeacherSpotlight } from './components/TeacherSpotlight';
import { MyAccount } from './components/MyAccount';
import { EditProfile, ProfileData } from './components/EditProfile';
import { Tab } from './components/BottomNav';
import { loadProfile, saveProfile, deriveNameFromEmail } from './components/profileStorage';

type Screen =
  | 'login'
  | 'onboarding1'
  | 'onboarding2'
  | 'dashboard'
  | 'grant-detail'
  | 'apply'
  | 'status'
  | 'teacher-spotlight'
  | 'account'
  | 'edit-profile';

export default function App() {
  const [screen, setScreen] = useState<Screen>('login');
  const [teacherName, setTeacherName] = useState('');
  const [teacherEmail, setTeacherEmail] = useState('');
  const [school, setSchool] = useState('');
  const [schoolLevel, setSchoolLevel] = useState('');
  const [subjects, setSubjects] = useState<string[]>([]);
  const [titleI, setTitleI] = useState(false);
  const [selectedGrantId, setSelectedGrantId] = useState('1');
  const [activeTab, setActiveTab] = useState<Tab>('grants');

  function handleLogin(name: string, email: string) {
    setTeacherEmail(email);
    const stored = loadProfile(email);
    if (stored) {
      setTeacherName(stored.name);
      setSchool(stored.school);
      setSchoolLevel(stored.schoolLevel);
      setSubjects(stored.subjects);
      setTitleI(stored.titleI);
      setActiveTab('grants');
      setScreen('dashboard');
    } else {
      setTeacherName(name || deriveNameFromEmail(email));
      setSchool('');
      setSchoolLevel('');
      setSubjects([]);
      setTitleI(false);
      setScreen('onboarding1');
    }
  }

  function handleLogout() {
    setTeacherName('');
    setTeacherEmail('');
    setSchool('');
    setSchoolLevel('');
    setSubjects([]);
    setTitleI(false);
    setScreen('login');
  }

  function toggleSubject(s: string) {
    setSubjects(prev => prev.includes(s) ? prev.filter(x => x !== s) : [...prev, s]);
  }

  function finishOnboarding() {
    saveProfile(teacherEmail, { name: teacherName, school, schoolLevel, subjects, titleI });
    setActiveTab('grants');
    setScreen('dashboard');
  }

  function saveProfileEdits(data: ProfileData) {
    setTeacherName(data.name);
    setSchool(data.school);
    setSchoolLevel(data.schoolLevel);
    setSubjects(data.subjects);
    setTitleI(data.titleI);
    saveProfile(teacherEmail, data);
    setScreen('account');
  }

  function handleTabChange(tab: Tab) {
    setActiveTab(tab);
    if (tab === 'apply') setScreen('apply');
    else if (tab === 'status') setScreen('status');
    else if (tab === 'account') setScreen('account');
    else setScreen('dashboard');
  }

  return (
    <div
      className="flex items-start justify-center min-h-screen w-full"
      style={{ background: '#E8EDF2' }}
    >
      <div
        className="relative overflow-hidden bg-white"
        style={{ width: '100%', maxWidth: 430, minHeight: '100vh', height: '100vh', display: 'flex', flexDirection: 'column' }}
      >
        {screen === 'login' && (
          <LoginScreen onLogin={handleLogin} />
        )}

        {screen === 'onboarding1' && (
          <OnboardingStep1
            selected={schoolLevel}
            onSelect={setSchoolLevel}
            school={school}
            onSchoolChange={setSchool}
            titleI={titleI}
            onTitleIChange={setTitleI}
            onNext={() => setScreen('onboarding2')}
          />
        )}

        {screen === 'onboarding2' && (
          <OnboardingStep2
            selected={subjects}
            onToggle={toggleSubject}
            onFinish={finishOnboarding}
            onBack={() => setScreen('onboarding1')}
          />
        )}

        {screen === 'dashboard' && (
          <Dashboard
            teacherName={teacherName}
            school={school}
            schoolLevel={schoolLevel}
            subjects={subjects}
            titleI={titleI}
            onGrantSelect={id => { setSelectedGrantId(id); setScreen('grant-detail'); }}
            onTeacherSpotlight={() => setScreen('teacher-spotlight')}
            onAccountPress={() => { setActiveTab('account'); setScreen('account'); }}
            activeTab={activeTab}
            onTabChange={handleTabChange}
          />
        )}

        {screen === 'grant-detail' && (
          <GrantDetails
            grantId={selectedGrantId}
            onBack={() => setScreen('dashboard')}
            onApply={id => { setSelectedGrantId(id); setActiveTab('status'); setScreen('status'); }}
          />
        )}

        {screen === 'apply' && (
          <ApplicationForm
            grantId={selectedGrantId}
            onBack={() => setScreen('grant-detail')}
            onSubmit={() => { setActiveTab('status'); setScreen('status'); }}
          />
        )}

        {screen === 'status' && (
          <ApplicationStatus
            activeTab={activeTab}
            onTabChange={handleTabChange}
          />
        )}

        {screen === 'teacher-spotlight' && (
          <TeacherSpotlight onBack={() => setScreen('dashboard')} />
        )}

        {screen === 'account' && (
          <MyAccount
            name={teacherName}
            email={teacherEmail}
            school={school}
            schoolLevel={schoolLevel}
            subjects={subjects}
            titleI={titleI}
            onEditProfile={() => setScreen('edit-profile')}
            onLogout={handleLogout}
            activeTab={activeTab}
            onTabChange={handleTabChange}
          />
        )}

        {screen === 'edit-profile' && (
          <EditProfile
            initial={{ name: teacherName, school, schoolLevel, subjects, titleI }}
            onSave={saveProfileEdits}
            onCancel={() => setScreen('account')}
          />
        )}
      </div>
    </div>
  );
}
