import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

const AddDepartment: React.FC = () => {
  const [name, setName] = useState<string>('');
  const [college_id, setCollegeId] = useState<string>('');
  const navigate = useNavigate();

  useEffect(() => {
    const storedCollegeId = localStorage.getItem('collegeId');
    if (storedCollegeId) {
      setCollegeId(storedCollegeId);
    } else {
      alert('No college ID found in local storage. Please sign in.');
      navigate('/');
    }
  }, []);

  const handleAdd = async () => {
    try {
      const payload: Record<string, any> = {
        name,
        college_id: college_id,
      };

      const response = await fetch(
        'http://localhost:3000/api/department/create',
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
        navigate('/departments');
      } else {
        alert(data.message);
      }
    } catch (err) {
      alert('Error adding member.');
    }
  };

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Add Department</h1>
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
        <button
          type="submit"
          className="bg-blue-500 text-white px-4 py-2 rounded"
        >
          Add Department
        </button>
      </form>
    </div>
  );
};

export default AddDepartment;
