import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';

const AddNews: React.FC = () => {
  const [title, setTitle] = useState<string>('');
  const [description, setDescription] = useState<string>('');
  const [creatorName, setCreatorName] = useState<string>('');
  const [location, setLocation] = useState<string>('');
  const [newsLink, setNewsLink] = useState<string>('');
  const [newsPosted, setNewsPosted] = useState<string>('');
  const [image, setImage] = useState<File | null>(null);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>('');

  const navigate = useNavigate();

  const handleImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files) {
      setImage(e.target.files[0]);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const collegeId = localStorage.getItem('collegeId');
    if (!collegeId) {
      setError('No college ID found in localStorage');
      return;
    }

    const formData = new FormData();
    formData.append('college_id', collegeId);
    formData.append('title', title);
    formData.append('description', description);
    formData.append('creator_name', creatorName);
    formData.append('location', location);
    formData.append('news_link', newsLink);
    formData.append('news_posted', newsPosted);

    if (image) {
      formData.append('image', image);
    }

    setLoading(true);

    try {
      const response = await fetch('http://localhost:3000/api/news/create', {
        method: 'POST',
        body: formData,
      });

      const data = await response.json();
      if (data.status === 'ok') {
        setError('');
        navigate('/news'); // Redirect to the news list page
      } else {
        setError(data.message);
      }
    } catch (error) {
      setError('Error creating news');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Add News</h1>

      {loading && <p>Loading...</p>}
      {error && <p className="text-red-500">{error}</p>}

      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block">Title</label>
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            className="w-full p-2 border"
            required
          />
        </div>

        <div>
          <label className="block">Description</label>
          <textarea
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            className="w-full p-2 border"
            required
          />
        </div>

        <div>
          <label className="block">Creator Name</label>
          <input
            type="text"
            value={creatorName}
            onChange={(e) => setCreatorName(e.target.value)}
            className="w-full p-2 border"
            required
          />
        </div>

        <div>
          <label className="block">Location</label>
          <input
            type="text"
            value={location}
            onChange={(e) => setLocation(e.target.value)}
            className="w-full p-2 border"
            required
          />
        </div>

        <div>
          <label className="block">News Link</label>
          <input
            type="text"
            value={newsLink}
            onChange={(e) => setNewsLink(e.target.value)}
            className="w-full p-2 border"
            required
          />
        </div>

        <div>
          <label className="block">News Posted Date</label>
          <input
            type="date"
            value={newsPosted}
            onChange={(e) => setNewsPosted(e.target.value)}
            className="w-full p-2 border"
            required
          />
        </div>

        <div>
          <label className="block">Upload Image</label>
          <input
            type="file"
            onChange={handleImageChange}
            className="w-full p-2 border"
          />
        </div>

        <button
          type="submit"
          className="bg-blue-500 text-white px-4 py-2 rounded mt-4"
        >
          Create News
        </button>
      </form>
    </div>
  );
};

export default AddNews;
