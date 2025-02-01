import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';

const EditMember: React.FC = () => {
  const { id } = useParams();
  const [member, setMember] = useState<any>({
    name: '',
    linkedin_url: '',
    completed_year: '',
    current_year: '',
    mobile_number: '',
    email: '',
    designation: '',
    role: '',
  });
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  const navigate = useNavigate();

  useEffect(() => {
    fetchMember();
  }, [id]);

  const fetchMember = async () => {
    try {
      const response = await fetch(`http://localhost:3000/api/member/${id}`);
      const data = await response.json();

      if (data.status === 'ok') {
        setMember(data.alumni);
      } else {
        setError(data.message);
      }
    } catch (err) {
      setError('Error fetching member details.');
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      const response = await fetch('http://localhost:3000/api/member/update', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          id,
          name: member.name,
          linkedin_url: member.linkedin_url,
          completed_year: member.completed_year,
          current_year: member.current_year,
          mobile_number: member.mobile_number,
          email: member.email,
          designation: member.designation,
        }),
      });

      const data = await response.json();

      if (data.status === 'ok') {
        const roleResponse = await fetch(
          'http://localhost:3000/api/member/updateRole',
          {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({
              alumni_id: id,
              role: member.role,
            }),
          },
        );

        const roleData = await roleResponse.json();

        if (roleData.status === 'ok') {
          navigate('/members');
        } else {
          alert(roleData.message);
        }
      } else {
        alert(data.message);
      }
    } catch (err) {
      alert('Error updating member.');
    }
  };

  if (loading) {
    return <p>Loading member details...</p>;
  }

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Edit Member</h1>
      {error && <p className="text-red-500">{error}</p>}
      <form onSubmit={handleEdit} className="space-y-4">
        <input
          type="text"
          placeholder="Name"
          value={member.name}
          onChange={(e) => setMember({ ...member, name: e.target.value })}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="text"
          placeholder="LinkedIn URL"
          value={member.linkedin_url}
          onChange={(e) =>
            setMember({ ...member, linkedin_url: e.target.value })
          }
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="text"
          placeholder="Mobile Number"
          value={member.mobile_number}
          onChange={(e) =>
            setMember({ ...member, mobile_number: e.target.value })
          }
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="email"
          placeholder="Email"
          value={member.email}
          onChange={(e) => setMember({ ...member, email: e.target.value })}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="text"
          placeholder="Designation"
          value={member.designation}
          onChange={(e) =>
            setMember({ ...member, designation: e.target.value })
          }
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="text"
          placeholder="Role"
          value={member.role}
          onChange={(e) => setMember({ ...member, role: e.target.value })}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <button
          type="submit"
          className="bg-green-500 text-white px-4 py-2 rounded"
        >
          Save Changes
        </button>
      </form>
    </div>
  );
};

export default EditMember;
