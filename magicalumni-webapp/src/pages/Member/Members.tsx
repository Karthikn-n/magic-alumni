import React, { useEffect, useState } from 'react';
import { BiSolidCommentError } from 'react-icons/bi';
import ConfirmModal from './ConfirmModal';
import { Link } from 'react-router-dom';
import './Members.css';

interface Member {
  _id: string;
  alumni_id: string;
  college_id: string;
  department_id: string;
  completed_year: string;
  status: string;
  name: string;
  mobile_number: string;
  linkedin_url: string;
  email: string;
  createdAt: string;
  updatedAt: string;
  role: string;
}

const Members: React.FC = () => {
  const [members, setMembers] = useState<Member[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  const [showModal, setShowModal] = useState(false);
  const [memberIdToDelete, setMemberIdToDelete] = useState<string>('');
  // const [memberIdToRequest, setMemberIdToRequest] = useState<string>('');
  const collegeId = localStorage.getItem('collegeId');

  useEffect(() => {
    if (collegeId) {
      fetchMembers();
    } else {
      console.error('No college ID found, please sign in.');
    }
  }, []);

  const fetchMembers = async () => {
    try {
      const response = await fetch(
        'http://localhost:3000/api/member/allMembers',
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
        setMembers(data.alumniDetails);
      } else {
        setError(data.message);
      }
    } catch (err) {
      setError('Error fetching members.');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async (id: string) => {
    setMemberIdToDelete(id);
    setShowModal(true);
  };

  // const handleRequest = async (id: string) => {
  //   setMemberIdToRequest(id);
  //   setShowModal(true);
  // };

  const confirmDelete = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/member/delete', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ id: memberIdToDelete }),
      });

      const data = await response.json();

      if (data.status === 'ok') {
        fetchMembers();
        setShowModal(false);
      } else {
        setError(data.message);
      }
    } catch (err) {
      setError('Error deleting member.');
    }
  };

  const cancelDelete = () => {
    setShowModal(false);
  };

  const requestRole = async (id: string) => {
    try {
      const response = await fetch(
        'http://localhost:3000/api/colleges/requestRole',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            college_id: collegeId,
            alumni_id: id,
          }),
        },
      );
      console.log(id);
      const data = await response.json();

      if (data.status === 'ok') {
        alert('Request sent successfully!');
      } else {
        setError(data.message);
      }
    } catch (err) {
      setError('Error sending request.');
    }
  };

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Members</h1>

      {loading && <p>Loading...</p>}
      {error && <p className="text-red-500">{error}</p>}
      <Link
        to="/add-member"
        className="bg-blue-500 text-white px-4 py-2 rounded mb-4 inline-block"
      >
        Add Member
      </Link>
      <table className="table-auto w-full border-collapse border border-gray-300 mt-4">
        <thead>
          <tr className="bg-gray-200">
            <th className="border border-gray-300 px-4 py-2">#</th>
            <th className="border border-gray-300 px-4 py-2">Name</th>
            <th className="border border-gray-300 px-4 py-2">Email</th>
            <th className="border border-gray-300 px-4 py-2">Mobile Number</th>
            <th className="border border-gray-300 px-4 py-2">LinkedIn URL</th>
            <th className="border border-gray-300 px-4 py-2">Role</th>
            <th className="border border-gray-300 px-4 py-2">Actions</th>
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
                  {member.name}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {member.email}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {member.mobile_number}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {member.linkedin_url}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {member.role}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  <Link
                    to={`/edit-member/${member._id}`}
                    className="text-blue-500 hover:underline mr-2"
                  >
                    Edit
                  </Link>
                  <button
                    onClick={() => handleDelete(member._id)}
                    className="text-red-500"
                  >
                    Delete
                  </button>
                  <button
                    onClick={() => requestRole(member._id)}
                    className="text-blue-500"
                  >
                    <BiSolidCommentError title="Request for Alumni Co-ordinator" />
                  </button>
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={11} className="border border-gray-300 px-4 py-2">
                No members joined
              </td>
            </tr>
          )}
        </tbody>
      </table>
      <ConfirmModal
        show={showModal}
        onConfirm={confirmDelete}
        onCancel={cancelDelete}
      />
    </div>
  );
};

export default Members;
