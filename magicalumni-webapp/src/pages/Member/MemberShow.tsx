import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

interface College {
  _id: string;
  name: string;
  address: string;
  city: string;
}

interface Department {
  _id: string;
  name: string;
}

interface AlumniCollegeData {
  _id: string;
  completed_year: string;
  status: string;
  college_id: College;
  department_id: Department;
}

interface MemberDetails {
  _id: string;
  name: string;
  role: string;
  linkedin_url: string;
  mobile_number: string;
  email: string;
  alumniCollegeData: AlumniCollegeData[];
  [key: string]: any;
}

const MemberDetails: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  const [member, setMember] = useState<MemberDetails | null>(null);

  useEffect(() => {
    if (id) {
      fetchMemberDetails();
    }
  }, [id]);

  const fetchMemberDetails = async () => {
    try {
      const response = await fetch(`http://localhost:3000/api/member/${id}`);
      const data = await response.json();

      if (data.status === 'ok') {
        setMember(data.alumni);
      } else {
        setError(data.message || 'Error fetching member details.');
      }
    } catch (err) {
      setError('Error fetching member details.');
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <p>Loading...</p>;
  if (error) return <p className="text-red-500">{error}</p>;

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Member Details</h1>

      {member && (
        <div className="bg-white shadow-md rounded p-6">
          <h2 className="text-xl font-semibold mb-4">{member.name}</h2>
          <p className="text-gray-700 mb-2">
            <strong>Mobile Number:</strong> {member.mobile_number || 'N/A'}
          </p>
          <p className="text-gray-700 mb-2">
            <strong>Email:</strong> {member.email || 'N/A'}
          </p>
          <p className="text-gray-700 mb-2">
            <strong>LinkedIn URL:</strong> {member.linkedin_url}
          </p>
          <p className="text-gray-700 mb-2">
            <strong>Role:</strong> {member.role || 'N/A'}
          </p>

          <h3 className="text-lg font-semibold mt-6 mb-4">
            Alumni College Details
          </h3>
          {member.alumniCollegeData.length > 0 ? (
            member.alumniCollegeData.map((collegeData, index) => (
              <div
                key={collegeData._id}
                className="mb-4 p-4 bg-gray-100 rounded shadow-sm"
              >
                <h4 className="text-md font-semibold">
                  College: {collegeData.college_id.name}
                </h4>
                <p className="text-gray-700">
                  <strong>Department:</strong> {collegeData.department_id.name}
                </p>
                <p className="text-gray-700">
                  <strong>Completed Year:</strong> {collegeData.completed_year}
                </p>
                <p className="text-gray-700">
                  <strong>Status:</strong> {collegeData.status}
                </p>
              </div>
            ))
          ) : (
            <p>No alumni college data available.</p>
          )}

          <button
            className="mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
            onClick={() => navigate(-1)}
          >
            Back
          </button>
        </div>
      )}
    </div>
  );
};

export default MemberDetails;
