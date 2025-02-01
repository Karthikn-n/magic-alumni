import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
interface News {
  _id: string;
  title: string;
  description: string;
  news_link: string;
  creator_name: string;
  news_posted: string;
  location: string;
  createdAt: string;
}

const NewsList: React.FC = () => {
  const [newsList, setNewsList] = useState<News[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');

  useEffect(() => {
    const collegeId = localStorage.getItem('collegeId');

    if (collegeId) {
      fetchNews(collegeId);
    } else {
      setError('No college ID found in localStorage');
      setLoading(false);
    }
  }, []);

  const fetchNews = async (collegeId: string) => {
    try {
      const response = await fetch('http://localhost:3000/api/news/list', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ college_id: collegeId }),
      });

      const data = await response.json();

      if (data.status === 'ok') {
        setNewsList(data.newsList);
      } else {
        setError(data.message);
      }
    } catch (error) {
      setError('Error fetching news data');
    } finally {
      setLoading(false);
    }
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
      <h1 className="text-2xl font-bold mb-4">News</h1>

      {loading && <p>Loading...</p>}
      {error && <p className="text-red-500">{error}</p>}
      <Link
        to="/add-news"
        className="bg-blue-500 text-white px-4 py-2 rounded mb-4 inline-block"
      >
        Add News
      </Link>
      <table className="table-auto w-full border-collapse border border-gray-300 mt-4">
        <thead>
          <tr className="bg-gray-200">
            <th className="border border-gray-300 px-4 py-2">#</th>
            <th className="border border-gray-300 px-4 py-2">Title</th>
            <th className="border border-gray-300 px-4 py-2">Description</th>
            <th className="border border-gray-300 px-4 py-2">Date</th>
            <th className="border border-gray-300 px-4 py-2">Creator Name</th>
            <th className="border border-gray-300 px-4 py-2">Location</th>
            <th className="border border-gray-300 px-4 py-2">Link</th>
          </tr>
        </thead>
        <tbody>
          {newsList && newsList.length > 0 ? (
            newsList.map((newsLists, index) => (
              <tr key={newsLists._id} className="hover:bg-gray-100">
                <td className="border border-gray-300 px-4 py-2">
                  {index + 1}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {newsLists.title}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {newsLists.description}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {newsLists.news_posted
                    ? formatDate(newsLists.news_posted)
                    : 'N/A'}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {newsLists.creator_name}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {newsLists.location}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {newsLists.news_link}
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={11} className="border border-gray-300 px-4 py-2">
                No news created
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default NewsList;
