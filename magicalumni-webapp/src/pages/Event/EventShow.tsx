import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

interface EventDetails {
  _id: string;
  event_title: string;
  date: string;
  description: string;
  approval_status: string;
  created_at: string;
  updated_at: string;
  event_image: string;
  [key: string]: any;
}

const EventDetails: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  const [event, setEvent] = useState<EventDetails | null>(null);

  useEffect(() => {
    if (id) {
      fetchEventDetails();
    }
  }, [id]);

  const fetchEventDetails = async () => {
    try {
      const response = await fetch(`http://localhost:3000/api/event/${id}`);
      const data = await response.json();

      if (data.status === 'ok') {
        setEvent(data.event);
      } else {
        setError(data.message || 'Error fetching event details.');
      }
    } catch (err) {
      setError('Error fetching event details.');
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

  if (loading) return <p>Loading...</p>;
  if (error) return <p className="text-red-500">{error}</p>;

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Event Details</h1>

      {event && (
        <div className="bg-white shadow-md rounded p-6">
          <h2 className="text-xl font-semibold mb-4">{event.event_title}</h2>
          {event.event_image && (
            <div className="mb-4">
              <img
                src={`http://localhost:3000${event.event_image}`}
                alt="Event Thumbnail"
                className="w-64 h-40 object-cover rounded shadow"
                style={{ objectFit: 'contain' }}
              />
            </div>
          )}
          <p className="text-gray-700 mb-2">
            <strong>Description:</strong> {event.description || 'N/A'}
          </p>
          <p className="text-gray-700 mb-2">
            <strong>Type:</strong> {event.event_type || 'N/A'}
          </p>
          <p className="text-gray-700 mb-2">
            <strong>Status:</strong> {event.approval_status}
          </p>
          <p className="text-gray-700 mb-2">
            <strong>Location:</strong> {event.location || 'N/A'}
          </p>
          <p className="text-gray-700 mb-2">
            <strong>Date:</strong> {event.date ? formatDate(event.date) : 'N/A'}
          </p>
          <p className="text-gray-700 mb-2">
            <strong>Criteria:</strong> {event.criteria || 'N/A'}
          </p>

          <button
            className="mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
            onClick={() => navigate(-1)}
          >
            Back
          </button>
        </div>
      )}
    </div>
  );
};

export default EventDetails;
