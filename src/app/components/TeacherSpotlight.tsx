import { ChevronLeft, MapPin, Award, Star, ExternalLink, Heart } from 'lucide-react';
import { ImageWithFallback } from './figma/ImageWithFallback';

interface Props {
  onBack: () => void;
}

export function TeacherSpotlight({ onBack }: Props) {
  return (
    <div className="flex flex-col h-full bg-white overflow-y-auto">
      {/* Hero image */}
      <div className="relative w-full" style={{ height: 300 }}>
        <ImageWithFallback
          src="https://images.unsplash.com/photo-1758685847967-c598c3b176b0?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixlib=rb-4.1.0&q=80&w=1080"
          alt="Maria Okonkwo, Teacher of the Month"
          className="w-full h-full object-cover"
        />
        {/* Gradient overlay */}
        <div
          className="absolute inset-0"
          style={{ background: 'linear-gradient(to bottom, rgba(0,0,0,0.25) 0%, rgba(0,0,0,0.0) 40%, rgba(0,0,0,0.55) 100%)' }}
        />
        {/* Back button */}
        <button
          onClick={onBack}
          className="absolute top-12 left-5 w-9 h-9 rounded-full flex items-center justify-center"
          style={{ background: 'rgba(0,0,0,0.35)', backdropFilter: 'blur(6px)' }}
        >
          <ChevronLeft size={20} color="#fff" />
        </button>
        {/* Badge */}
        <div
          className="absolute top-12 right-5 flex items-center gap-1.5 px-3 py-1.5 rounded-full"
          style={{ background: '#134F34' }}
        >
          <Star size={11} color="#F5C842" fill="#F5C842" />
          <span style={{ fontSize: '10px', fontWeight: 700, color: '#A7D9BC', letterSpacing: '0.08em' }}>
            TEACHER OF THE MONTH
          </span>
        </div>
        {/* Name overlay */}
        <div className="absolute bottom-0 left-0 right-0 px-5 pb-5">
          <h1 style={{ fontSize: '26px', fontWeight: 800, color: '#fff', lineHeight: 1.1 }}>Maria Okonkwo</h1>
        </div>
      </div>

      {/* Info row */}
      <div className="px-5 py-4 bg-white" style={{ borderBottom: '1px solid #F0F0F0' }}>
        <div className="flex items-center gap-2 mb-1">
          <MapPin size={13} color="#1B7A50" />
          <span style={{ fontSize: '13px', color: '#374151', fontWeight: 500 }}>
            Langston Hughes Middle School
          </span>
          <span style={{ fontSize: '13px', color: '#9CA3AF' }}>·</span>
          <span style={{ fontSize: '13px', color: '#6B7280' }}>Granite Falls Community District</span>
        </div>
        <div className="flex items-center gap-4 mt-2">
          <div className="flex items-center gap-1.5">
            <Award size={13} color="#1B7A50" />
            <span style={{ fontSize: '12px', color: '#1B7A50', fontWeight: 600 }}>$4,800 Grant Received</span>
          </div>
          <span style={{ fontSize: '12px', color: '#9CA3AF' }}>·</span>
          <span style={{ fontSize: '12px', color: '#6B7280' }}>3 yrs teaching</span>
          <span style={{ fontSize: '12px', color: '#9CA3AF' }}>·</span>
          <span style={{ fontSize: '12px', color: '#6B7280' }}>7th Grade Science</span>
        </div>
      </div>

      {/* Quote */}
      <div
        className="mx-5 mt-5 mb-5 p-5 rounded-2xl"
        style={{ background: '#EBF6F0', borderLeft: '4px solid #1B7A50' }}
      >
        <p style={{ fontSize: '15px', fontStyle: 'italic', color: '#134F34', lineHeight: 1.7, fontWeight: 500 }}>
          "My students don't just need textbooks. They need to see that someone believed in them enough to invest in their imagination."
        </p>
        <p className="mt-3" style={{ fontSize: '12px', color: '#4D9E72', fontWeight: 600 }}>
          — Maria Okonkwo, 7th Grade Science Teacher
        </p>
      </div>

      {/* Story */}
      <div className="px-5">
        <p className="text-gray-700 mb-4" style={{ fontSize: '14px', lineHeight: 1.75 }}>
          When Maria Okonkwo walked into her 7th-grade classroom at Langston Hughes Middle School for the first time, she made her students a quiet promise: that science wouldn't feel like a punishment. Seven years later, she's kept that promise — and a $4,800 adaptive learning grant from IncludeAll Foundation has helped her take it further than she imagined.
        </p>
        <p className="text-gray-700 mb-4" style={{ fontSize: '14px', lineHeight: 1.75 }}>
          The funding allowed Maria to redesign her classroom's back corner into a sensory regulation station — soft lighting, fidget tools, a standing desk, and noise-canceling headphones. Three students previously labeled with "behavioral issues" now lead the class in science project participation.
        </p>
        <p className="text-gray-700 mb-6" style={{ fontSize: '14px', lineHeight: 1.75 }}>
          "Every kid deserves the chance to focus," she says. "This grant didn't just buy equipment. It told my students: you matter enough to be here."
        </p>

        {/* Grant received card */}
        <div
          className="p-4 rounded-2xl mb-6"
          style={{ background: '#F8FAFB', border: '1px solid #E5E7EB' }}
        >
          <p style={{ fontSize: '10px', fontWeight: 700, letterSpacing: '0.08em', color: '#9CA3AF', marginBottom: '8px' }}>
            GRANT RECEIVED
          </p>
          <p style={{ fontSize: '13px', fontWeight: 700, color: '#1B7A50' }}>IncludeAll Foundation</p>
          <p style={{ fontSize: '14px', fontWeight: 700, color: '#111827', marginTop: '2px' }}>
            Adaptive Learning Tools for Neurodiverse Students
          </p>
          <div className="flex items-center gap-3 mt-3">
            <span
              className="px-2.5 py-1 rounded-full"
              style={{ fontSize: '12px', fontWeight: 600, background: '#EBF6F0', color: '#1B7A50' }}
            >
              $4,800 Funded
            </span>
            <span style={{ fontSize: '12px', color: '#6B7280' }}>Received Sept 2023</span>
          </div>
          <p className="mt-3" style={{ fontSize: '12px', color: '#6B7280', lineHeight: 1.5 }}>
            Provided classroom redesign support, assistive learning tools, standing desk, and noise-canceling headphones for 4 students with sensory needs.
          </p>
        </div>

        {/* From the classroom */}
        <div
          className="p-4 rounded-2xl mb-8"
          style={{ background: '#FFF8E7', border: '1px solid #FFE4A3' }}
        >
          <p style={{ fontSize: '10px', fontWeight: 700, letterSpacing: '0.08em', color: '#9CA3AF', marginBottom: '6px' }}>
            FROM THE CLASSROOM
          </p>
          <p style={{ fontSize: '13px', color: '#7A5C00', lineHeight: 1.6, fontStyle: 'italic' }}>
            "Know an amazing teacher? You can nominate them in less than 2 minutes."
          </p>
        </div>

        {/* Nominate button */}
        <button
          className="w-full py-4 mb-4 rounded-2xl flex items-center justify-center gap-2 transition-all active:scale-[0.98]"
          style={{ background: '#1B7A50', color: '#fff', fontWeight: 700, fontSize: '16px' }}
        >
          <Heart size={17} fill="rgba(255,255,255,0.3)" color="#fff" />
          Nominate a Teacher
        </button>

        <p className="text-center mb-10" style={{ fontSize: '12px', color: '#9CA3AF' }}>
          Spotlight nominations close the 25th of each month.
        </p>
      </div>
    </div>
  );
}
