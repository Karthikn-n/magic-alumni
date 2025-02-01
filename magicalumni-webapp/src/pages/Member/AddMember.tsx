import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const AddMember: React.FC = () => {
  const [name, setName] = useState<string>('');
  const [linkedin_url, setLinkedinUrl] = useState<string>('');
  const [completed_year, setCompletedYear] = useState<string>('');
  const [current_year, setCurrentYear] = useState<string>('');
  const [college_id, setCollegeId] = useState<string>('');
  const [mobile_number, setMobileNumber] = useState<string>('');
  const [designation, setDesignation] = useState<string>('');
  const [email, setEmail] = useState<string>('');
  const [role, setRole] = useState<string>('');
  const [department_id, setDepartmentId] = useState<string>('');
  const [departments, setDepartments] = useState<any[]>([]);
  const navigate = useNavigate();

  useEffect(() => {
    const storedCollegeId = localStorage.getItem('collegeId');
    if (storedCollegeId) {
      setCollegeId(storedCollegeId);
      fetchDepartments(storedCollegeId);
    } else {
      alert('No college ID found in local storage. Please sign in.');
      navigate('/');
    }
  }, []);

  const fetchDepartments = async (collegeId: string) => {
    try {
      const response = await fetch(
        `http://localhost:3000/api/department/list`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ college_id: collegeId }),
        },
      );

      console.log('Response Status:', response.status);
      console.log('Response Headers:', response.headers);

      const data = await response.json();

      console.log('Response Data:', data);

      if (data.status === 'ok') {
        setDepartments(data.departmentList);
      } else {
        alert('Failed to fetch departments: ' + data.message);
      }
    } catch (err) {
      alert('Error adding member.');
    }
  };

  const handleAdd = async () => {
    try {
      const payload: Record<string, any> = {
        name,
        linkedin_url,
        college_id,
        mobile_number,
        email,
        department_id,
      };

      if (role === 'Student') {
        payload.current_year = current_year;
        payload.role = role;
      } else {
        payload.completed_year = completed_year;
        payload.designation = designation;
      }

      const response = await fetch(
        'http://localhost:3000/api/member/register',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(payload),
        },
      );

      const data = await response.json();
      if (data.status === 'ok') {
        alert(data.message);
        navigate('/members');
      } else {
        alert(data.message);
      }
    } catch (err) {
      alert('Error adding member.');
    }
  };

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Add Member</h1>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          handleAdd();
        }}
        className="space-y-4"
      >
        <input
          type="text"
          placeholder="Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
          required
        />
        <input
          type="text"
          placeholder="LinkedIn URL"
          value={linkedin_url}
          onChange={(e) => setLinkedinUrl(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="text"
          placeholder="Mobile Number"
          value={mobile_number}
          onChange={(e) => setMobileNumber(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
          required
        />
        <input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
          required
        />
        <select
          value={role}
          onChange={(e) => setRole(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        >
          <option value="">Alumni</option>
          <option value="Student">Student</option>
        </select>
        {role === 'Student' ? (
          <input
            type="text"
            placeholder="Current Year"
            value={current_year}
            onChange={(e) => setCurrentYear(e.target.value)}
            className="block w-full p-2 border border-gray-300 rounded"
            required
          />
        ) : (
          <>
            <input
              type="text"
              placeholder="Designation"
              value={designation}
              onChange={(e) => setDesignation(e.target.value)}
              className="block w-full p-2 border border-gray-300 rounded"
            />
            <input
              type="text"
              placeholder="Completed Year"
              value={completed_year}
              onChange={(e) => setCompletedYear(e.target.value)}
              className="block w-full p-2 border border-gray-300 rounded"
            />
          </>
        )}
        <select
          value={department_id}
          onChange={(e) => setDepartmentId(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
          required
        >
          <option value="" disabled>
            Select Department
          </option>
          {departments && departments.length > 0 ? (
            departments.map((department, index) => (
              <option key={department._id} value={department._id}>
                {department.name}
              </option>
            ))
          ) : (
            <tr>
              <td colSpan={11} className="border border-gray-300 px-4 py-2">
                No department created
              </td>
            </tr>
          )}
        </select>
        <button
          type="submit"
          className="bg-blue-500 text-white px-4 py-2 rounded"
        >
          Add Member
        </button>
      </form>
    </div>
  );
};

export default AddMember;
