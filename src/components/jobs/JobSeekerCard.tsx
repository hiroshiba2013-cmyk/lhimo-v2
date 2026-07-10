import { MapPin, DollarSign, Calendar, MessageCircle, Phone, Mail, Tag } from 'lucide-react';

interface JobSeekerCardProps {
  jobSeeker: {
    id: string;
    user_id: string;
    title: string;
    description: string;
    skills: string[];
    contract_type: string;
    desired_salary_min: number | null;
    desired_salary_max: number | null;
    salary_currency: string;
    location: string;
    available_from: string | null;
    experience_years: number;
    education_level: string | null;
    phone: string | null;
    email: string | null;
    created_at: string;
    profiles: {
      full_name: string;
      nickname: string;
    };
    business_categories: {
      name: string;
    } | null;
  };
  onContact?: (jobSeekerId: string) => void;
  showContactButton?: boolean;
}

export function JobSeekerCard({ jobSeeker, onContact, showContactButton = true }: JobSeekerCardProps) {
  return (
    <a
      href={`/jobs/seekers/${jobSeeker.id}`}
      className="block bg-white rounded-lg shadow-md hover:shadow-lg transition-shadow p-6"
    >
      <div className="flex justify-between items-start mb-4">
        <div className="flex-1">
          <h3 className="text-xl font-bold text-gray-900 hover:text-blue-600 transition-colors">{jobSeeker.title}</h3>
          {jobSeeker.profiles && (
            <a
              href={`/professional-profile/${jobSeeker.user_id}`}
              onClick={(e) => e.stopPropagation()}
              className="text-gray-600 font-medium hover:text-blue-600 hover:underline transition-colors"
            >
              {jobSeeker.profiles.nickname || 'Candidato'}
            </a>
          )}
          {jobSeeker.business_categories && (
            <div className="flex items-center gap-1 mt-1">
              <Tag className="w-3 h-3 text-gray-500" />
              <span className="text-xs text-gray-500">{jobSeeker.business_categories.name}</span>
            </div>
          )}
        </div>
        <span className="px-3 py-1 bg-blue-100 text-blue-800 text-sm font-medium rounded-full">
          {jobSeeker.contract_type}
        </span>
      </div>

      <p className="text-gray-700 mb-4 line-clamp-3">{jobSeeker.description}</p>

      <div className="grid grid-cols-2 md:grid-cols-3 gap-4 mb-4">
        <div className="flex items-center gap-2">
          <MapPin className="w-4 h-4 text-gray-500" />
          <span className="text-sm text-gray-600">{jobSeeker.location}</span>
        </div>

        {jobSeeker.desired_salary_min && jobSeeker.desired_salary_max && (
          <div className="flex items-center gap-2">
            <DollarSign className="w-4 h-4 text-gray-500" />
            <span className="text-sm text-gray-600">
              {jobSeeker.desired_salary_min.toLocaleString()} - {jobSeeker.desired_salary_max.toLocaleString()} {jobSeeker.salary_currency}
            </span>
          </div>
        )}

        <div className="text-sm text-gray-600">
          <span className="font-medium">Esperienza:</span> {jobSeeker.experience_years} anni
        </div>

        {jobSeeker.education_level && (
          <div className="text-sm text-gray-600">
            <span className="font-medium">Istruzione:</span> {jobSeeker.education_level}
          </div>
        )}

        {jobSeeker.available_from && (
          <div className="flex items-center gap-2">
            <Calendar className="w-4 h-4 text-gray-500" />
            <span className="text-sm text-gray-600">
              Dal {new Date(jobSeeker.available_from).toLocaleDateString('it-IT')}
            </span>
          </div>
        )}
      </div>

      {jobSeeker.skills.length > 0 && (
        <div className="mb-4 flex flex-wrap gap-2">
          {jobSeeker.skills.map((skill, index) => (
            <span key={index} className="px-2 py-1 bg-gray-100 text-gray-700 text-xs rounded">
              {skill}
            </span>
          ))}
        </div>
      )}

      <div className="flex items-center justify-between">
        <span className="text-xs text-gray-500">
          Pubblicato il {new Date(jobSeeker.created_at).toLocaleDateString('it-IT')}
        </span>
        {showContactButton && onContact && (
          <button
            onClick={(e) => { e.preventDefault(); onContact(jobSeeker.id); }}
            className="flex items-center gap-2 px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 font-medium transition-colors"
          >
            <MessageCircle className="w-4 h-4" />
            Invia Messaggio
          </button>
        )}
      </div>
    </a>
  );
}