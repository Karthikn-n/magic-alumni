import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const AddEvent: React.FC = () => {
  const [job_title, setJobTitle] = useState<string>('');
  const [job_type, setJobType] = useState<string>('');
  const [last_date, setLastDate] = useState<string>('');
  const [company_name, setCompanyName] = useState<string>('');
  const [location, setLocation] = useState<string>('');
  const [job_url, setJobUrl] = useState<string>('');
  const [email, setEmail] = useState<string>('');
  const [tag, setTag] = useState<string>('');
  const navigate = useNavigate();

  const handleAddEvent = async () => {
    const college_id = localStorage.getItem('collegeId');

    if (!college_id) {
      alert('College ID is missing in localStorage.');
      return;
    }

    const tagArray = tag
      .split(',')
      .map((t) => t.trim())
      .filter(Boolean);

    const payload = {
      college_id,
      job_title,
      job_type,
      last_date,
      company_name,
      location,
      job_url,
      email,
      tag: tagArray,
    };

    try {
      const response = await fetch('http://localhost:3000/api/job/create', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(payload),
      });

      const data = await response.json();

      if (data.status === 'ok') {
        alert('Job created successfully!');
        navigate('/jobs');
      } else {
        alert(data.message || 'Error creating event.');
      }
    } catch (error) {
      console.error('Error creating event:', error);
      alert('An error occurred while creating the event.');
    }
  };

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Add Job</h1>
      <form
        onSubmit={(e) => {
          e.preventDefault();
          handleAddEvent();
        }}
        className="space-y-4"
      >
        <label htmlFor="job_title" className="block text-sm font-medium">
          Job Title
        </label>
        <input
          type="text"
          placeholder="Job Title"
          value={job_title}
          onChange={(e) => setJobTitle(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
          required
        />
        <label htmlFor="job_type" className="block text-sm font-medium">
          Job Type
        </label>
        <input
          type="text"
          placeholder="Job Type"
          value={job_type}
          onChange={(e) => setJobType(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <label htmlFor="last_date" className="block text-sm font-medium">
          Last Date to Apply
        </label>
        <input
          type="date"
          placeholder="Last Date"
          value={last_date}
          onChange={(e) => setLastDate(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
          required
        />
        <label htmlFor="company_name" className="block text-sm font-medium">
          Company Name
        </label>
        <input
          type="text"
          placeholder="Company Name"
          value={company_name}
          onChange={(e) => setCompanyName(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <label htmlFor="location" className="block text-sm font-medium">
          Location
        </label>
        <input
          type="text"
          placeholder="Location"
          value={location}
          onChange={(e) => setLocation(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <label htmlFor="job_url" className="block text-sm font-medium">
          Job URL
        </label>
        <input
          type="url"
          placeholder="Job URL"
          value={job_url}
          onChange={(e) => setJobUrl(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <label htmlFor="email" className="block text-sm font-medium">
          Email
        </label>
        <input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <label htmlFor="tag" className="block text-sm font-medium">
          Tags
        </label>
        <input
          type="text"
          placeholder="Tags (comma-separated)"
          value={tag}
          onChange={(e) => setTag(e.target.value)}
          className="block w-full p-2 border border-gray-300 rounded"
        />
        <button
          type="submit"
          className="bg-blue-500 text-white px-4 py-2 rounded"
        >
          Add Job
        </button>
      </form>
    </div>
  );
};

export default AddEvent;
