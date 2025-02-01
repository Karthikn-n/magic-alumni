import React, { useEffect, useState } from 'react';
import ConfirmModal from './ConfirmModal';
import { MdError } from 'react-icons/md';
import { Link } from 'react-router-dom';
import './Job.css';

interface Jobs {
  _id: string;
  job_title: string;
  job_type: string;
  last_date: string;
  email: String;
  company_name: string;
  location: string;
  job_url: string;
  tag: string;
}

const Job: React.FC = () => {
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  const [showModal, setShowModal] = useState(false);
  const [jobIdToDelete, setJobIdToDelete] = useState<string>('');
  const collegeId = localStorage.getItem('collegeId');
  const [job, setJob] = useState<Jobs[]>([]);

  useEffect(() => {
    if (collegeId) {
      fetchJob();
    } else {
      console.error('No college ID found, please sign in.');
    }
  }, []);

  const fetchJob = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/job/list', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ college_id: collegeId }),
      });
      const data = await response.json();

      if (data.status === 'ok') {
        setJob(data.jobList);
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
    setJobIdToDelete(id);
    setShowModal(true);
  };

  const confirmDelete = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/job/delete', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ id: jobIdToDelete }),
      });

      const data = await response.json();

      if (data.status === 'ok') {
        fetchJob();
        setShowModal(false);
      } else {
        setError(data.message);
      }
    } catch (err) {
      setError('Error deleting job.');
    }
  };

  const cancelDelete = () => {
    setShowModal(false);
  };

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', {
      month: 'long',
      day: 'numeric',
      year: 'numeric',
    });
  };

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Jobs</h1>

      {loading && <p>Loading...</p>}
      {error && <p className="text-red-500">{error}</p>}
      <Link
        to="/add-job"
        className="bg-blue-500 text-white px-4 py-2 rounded mb-4 inline-block"
      >
        Add Job
      </Link>
      <table className="table-auto w-full border-collapse border border-gray-300 mt-4">
        <thead>
          <tr className="bg-gray-200">
            <th className="border border-gray-300 px-4 py-2">#</th>
            <th className="border border-gray-300 px-4 py-2">Title</th>
            <th className="border border-gray-300 px-4 py-2">Type</th>
            <th className="border border-gray-300 px-4 py-2">Last Date</th>
            <th className="border border-gray-300 px-4 py-2">Company Name</th>
            <th className="border border-gray-300 px-4 py-2">Email ID</th>
            <th className="border border-gray-300 px-4 py-2">Location</th>
            <th className="border border-gray-300 px-4 py-2">ULR</th>
            <th className="border border-gray-300 px-4 py-2">Tags</th>
            <th className="border border-gray-300 px-4 py-2">Reports</th>
            <th className="border border-gray-300 px-4 py-2">Action</th>
          </tr>
        </thead>
        <tbody>
          {job && job.length > 0 ? (
            job.map((jobs, index) => (
              <tr key={jobs._id} className="hover:bg-gray-100">
                <td className="border border-gray-300 px-4 py-2">
                  {index + 1}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {jobs.job_title}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {jobs.job_type}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {jobs.last_date ? formatDate(jobs.last_date) : 'N/A'}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {jobs.company_name}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {jobs.email}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {jobs.location}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {jobs.job_url}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {Array.isArray(jobs.tag) ? jobs.tag.join(', ') : jobs.tag}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  <Link
                    to={`/reports/${jobs._id}`}
                    className="text-blue-500 hover:underline mr-2"
                  >
                    <MdError />
                  </Link>
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  <Link
                    to={`/edit-job/${jobs._id}`}
                    className="text-blue-500 hover:underline mr-2"
                  >
                    Edit
                  </Link>

                  <button
                    onClick={() => handleDelete(jobs._id)}
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
                No jobs created
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

export default Job;
