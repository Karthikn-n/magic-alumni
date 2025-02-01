import React, { useEffect, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';

const EditDepartment: React.FC = () => {
  const { id } = useParams();
  const [departement, setDepartement] = useState<{ name: string }>({
    name: '',
  });
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  const navigate = useNavigate();

  useEffect(() => {
    fetchDepartement();
  }, [id]);

  const fetchDepartement = async () => {
    try {
      const response = await fetch(
        `http://localhost:3000/api/department/${id}`,
      );
      const data = await response.json();

      if (data.status === 'ok' && data.departement) {
        setDepartement(data.departement);
      } else {
        setError(data.message || 'Department not found');
      }
    } catch (err) {
      setError('Error fetching department details.');
    } finally {
      setLoading(false);
    }
  };

  const handleEdit = async (e: React.FormEvent) => {
    e.preventDefault();

    try {
      const response = await fetch(
        'http://localhost:3000/api/department/update',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            id,
            name: departement.name,
          }),
        },
      );

      const data = await response.json();

      if (data.status === 'ok') {
        navigate('/departments');
      } else {
        alert(data.message);
      }
    } catch (err) {
      alert('Error updating department.');
    }
  };

  if (loading) {
    return <p>Loading department details...</p>;
  }

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Edit Department</h1>
      {error && <p className="text-red-500">{error}</p>}
      <form onSubmit={handleEdit} className="space-y-4">
        <input
          type="text"
          placeholder="Name"
          value={departement.name}
          onChange={(e) =>
            setDepartement({ ...departement, name: e.target.value })
          }
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

export default EditDepartment;
