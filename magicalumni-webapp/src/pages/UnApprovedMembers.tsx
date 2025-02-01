import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';

interface Members {
  _id: string;
  name: string;
  mobile_number: string;
  email: string;
  linkedin_url: string;
  role: string;
  status: string;
}

const UnApprovedMembers: React.FC = () => {
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  const [members, setMembers] = useState<Members[]>([]);
  const collegeId = localStorage.getItem('collegeId');

  useEffect(() => {
    if (collegeId) {
      fetchUnApproved();
    } else {
      console.error('No college ID found, please sign in.');
    }
  }, []);

  const fetchUnApproved = async () => {
    try {
      const response = await fetch(
        'http://localhost:3000/api/member/newMemberList',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ college_id: collegeId }),
        },
      );
      const data = await response.json();

      if (data.status === 'ok') {
        setMembers(data.alumni);
      } else {
        setError(data.message);
      }
    } catch (err) {
      setError('Error fetching members.');
    } finally {
      setLoading(false);
    }
  };

  const toggleApproval = async (alumni_id: string, status: string) => {
    try {
      const response = await fetch(
        'http://localhost:3000/api/member/updateMemberStatus',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            alumni_id,
            college_id: collegeId,
            status: status === 'approved' ? 'unapproved' : 'approved', // Toggle status
          }),
        },
      );

      const data = await response.json();

      if (data.status === 'ok') {
        setMembers((prevMembers) =>
          prevMembers.map((member) =>
            member._id === alumni_id
              ? { ...member, status: data.alumniCollege.status }
              : member,
          ),
        );
      } else {
        console.error(data.message);
      }
    } catch (error) {
      console.error('Error updating member status:', error);
    }
  };

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Un Approved Events</h1>

      {loading && <p>Loading...</p>}
      {error && <p className="text-red-500">{error}</p>}

      <table className="table-auto w-full border-collapse border border-gray-300 mt-4">
        <thead>
          <tr className="bg-gray-200">
            <th className="border border-gray-300 px-4 py-2">#</th>
            <th className="border border-gray-300 px-4 py-2">Name</th>
            <th className="border border-gray-300 px-4 py-2">Mobile Number</th>
            <th className="border border-gray-300 px-4 py-2">Email</th>
            <th className="border border-gray-300 px-4 py-2">LinkedIn URL</th>
            <th className="border border-gray-300 px-4 py-2">Role</th>
            <th className="border border-gray-300 px-4 py-2">Action</th>
          </tr>
        </thead>
        <tbody>
          {members && members.length > 0 ? (
            members.map((member, index) => (
              <tr key={member._id} className="hover:bg-gray-100">
                <td className="border border-gray-300 px-4 py-2">
                  {index + 1}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  <Link
                    to={`/member/${member._id}`}
                    className="text-blue-500 hover:underline"
                  >
                    {member.name}
                  </Link>
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {member.mobile_number}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {member.email}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {member.linkedin_url}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {member.role}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  <button
                    onClick={() => toggleApproval(member._id, member.status)}
                    className={`px-4 py-2 text-white rounded ${
                      member.status === 'approved'
                        ? 'bg-green-500'
                        : 'bg-red-500'
                    }`}
                  >
                    {member.status === 'approved' ? 'Unapprove' : 'Approve'}
                  </button>
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={11} className="border border-gray-300 px-4 py-2">
                No unApproved members
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default UnApprovedMembers;
