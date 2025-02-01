import React, { useState, useEffect } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

const EditEvent: React.FC = () => {
  const { id } = useParams();
  const navigate = useNavigate();

  const [job_title, setJobTitle] = useState<string>('');
  const [job_type, setJobType] = useState<string>('');
  const [last_date, setLastDate] = useState<string>('');
  const [company_name, setCompanyName] = useState<string>('');
  const [location, setLocation] = useState<string>('');
  const [job_url, setJobUrl] = useState<string>('');
  const [email, setEmail] = useState<string>('');
  const [tag, setTag] = useState<string>('');

  const [error, setError] = useState<string>('');
  const [loading, setLoading] = useState<boolean>(true);
  const formatDate = (date: string) => {
    const d = new Date(date);
    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  };

  useEffect(() => {
    const fetchEventData = async () => {
      try {
        const response = await fetch(`http://localhost:3000/api/job/${id}`);
        const data = await response.json();

        if (data.status === 'ok') {
          const jobData = data.job;
          setJobTitle(jobData.job_title);
          setJobType(jobData.job_type);
          setLastDate(formatDate(jobData.last_date));
          setCompanyName(jobData.company_name);
          setLocation(jobData.location);
          setJobUrl(jobData.job_url);
          setEmail(jobData.email);
          setTag(jobData.tag.join(', '));
        } else {
          setError(data.message);
        }
      } catch (error) {
        setError('Error fetching job data.');
      } finally {
        setLoading(false);
      }
    };

    fetchEventData();
  }, [id]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const tagsArray = tag.split(',').map((t) => t.trim());

    const updatedEvent = {
      id,
      job_title,
      job_type,
      last_date,
      company_name,
      location,
      job_url,
      email,
      tag: tagsArray,
    };

    try {
      const response = await fetch('http://localhost:3000/api/job/update', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(updatedEvent),
      });

      const data = await response.json();

      if (data.status === 'ok') {
        alert('Event updated successfully!');
        navigate('/jobs');
      } else {
        setError(data.message);
      }
    } catch (err) {
      setError('Error updating event.');
    }
  };

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Edit Event</h1>

      {loading && <p>Loading...</p>}
      {error && <p className="text-red-500">{error}</p>}

      <form onSubmit={handleSubmit} className="space-y-4">
        <input
          type="text"
          placeholder="Job Title"
          value={job_title}
          onChange={(e) => setJobTitle(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="text"
          placeholder="Job Type"
          value={job_type}
          onChange={(e) => setJobType(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="date"
          value={last_date}
          onChange={(e) => setLastDate(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="text"
          placeholder="Company Name"
          value={company_name}
          onChange={(e) => setCompanyName(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="text"
          placeholder="Location"
          value={location}
          onChange={(e) => setLocation(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="text"
          placeholder="Job URL"
          value={job_url}
          onChange={(e) => setJobUrl(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <input
          type="text"
          placeholder="Tags (comma-separated)"
          value={tag}
          onChange={(e) => setTag(e.target.value)}
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

export default EditEvent;
