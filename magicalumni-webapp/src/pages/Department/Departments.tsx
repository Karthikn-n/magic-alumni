import React, { useEffect, useState } from 'react';
import ConfirmModal from './ConfirmModal';
import { Link } from 'react-router-dom';
import './Departments.css';

interface Department {
  _id: string;
  college_id: string;
  name: string;
  address: String;
  city: String;
  createdAt: string;
  updatedAt: string;
}

const Departments: React.FC = () => {
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  const [showModal, setShowModal] = useState(false);
  const [departmentIdToDelete, setDepartmentIdToDelete] = useState<string>('');
  const [departments, setDepartments] = useState<Department[]>([]);
  const collegeId = localStorage.getItem('collegeId');

  useEffect(() => {
    if (collegeId) {
      fetchDepartments();
    } else {
      console.error('No college ID found, please sign in.');
    }
  }, []);

  const fetchDepartments = async () => {
    try {
      const response = await fetch(
        'http://localhost:3000/api/department/list',
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
        setDepartments(data.departmentList);
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
    setDepartmentIdToDelete(id);
    setShowModal(true);
  };

  const confirmDelete = async () => {
    try {
      const response = await fetch(
        'http://localhost:3000/api/department/delete',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({ id: departmentIdToDelete }),
        },
      );

      const data = await response.json();

      if (data.status === 'ok') {
        fetchDepartments();
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

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Departments</h1>

      {loading && <p>Loading...</p>}
      {error && <p className="text-red-500">{error}</p>}
      <Link
        to="/add-department"
        className="bg-blue-500 text-white px-4 py-2 rounded mb-4 inline-block"
      >
        Add Department
      </Link>
      <table className="table-auto w-full border-collapse border border-gray-300 mt-4">
        <thead>
          <tr className="bg-gray-200">
            <th className="border border-gray-300 px-4 py-2">#</th>
            <th className="border border-gray-300 px-4 py-2">Name</th>
            <th className="border border-gray-300 px-4 py-2">Actions</th>
          </tr>
        </thead>
        <tbody>
          {departments && departments.length > 0 ? (
            departments.map((department, index) => (
              <tr key={department._id} className="hover:bg-gray-100">
                <td className="border border-gray-300 px-4 py-2">
                  {index + 1}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {department.name}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  <Link
                    to={`/edit-department/${department._id}`}
                    className="text-blue-500 hover:underline mr-2"
                  >
                    Edit
                  </Link>
                  <button
                    onClick={() => handleDelete(department._id)}
                    className="text-red-500"
                  >
                    Delete
                  </button>
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={11} className="border border-gray-300 px-4 py-2">
                No department created
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

export default Departments;
