import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';

interface Event {
  _id: string;
  event_title: string;
  approval_status: boolean;
}

const UnApprovedEvents: React.FC = () => {
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  const [events, setEvents] = useState<Event[]>([]);
  const collegeId = localStorage.getItem('collegeId');

  useEffect(() => {
    if (collegeId) {
      fetchUnApproved();
    } else {
      console.error('No college ID found, please sign in.');
    }
  }, []);

  const fetchUnApproved = async () => {
    try {
      const response = await fetch(
        'http://localhost:3000/api/event/unapprovedlist',
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
        setEvents(data.eventList);
      } else {
        setError(data.message);
      }
    } catch (err) {
      setError('Error fetching events.');
    } finally {
      setLoading(false);
    }
  };

  const toggleApproval = async (eventId: string, status: boolean) => {
    try {
      const response = await fetch(
        'http://localhost:3000/api/event/updateStatus',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            event_id: eventId,
            college_id: collegeId,
            status: status ? 'not approved' : 'approved',
          }),
        },
      );
      const data = await response.json();

      if (data.status === 'ok') {
        setEvents((prevEvents) =>
          prevEvents.map((event) =>
            event._id === eventId
              ? { ...event, approval_status: status }
              : event,
          ),
        );
      } else {
        console.error(data.message);
      }
    } catch (error) {
      console.error('Error updating event status:', error);
    }
  };

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Un Approved Events</h1>

      {loading && <p>Loading...</p>}
      {error && <p className="text-red-500">{error}</p>}

      <table className="table-auto w-full border-collapse border border-gray-300 mt-4">
        <thead>
          <tr className="bg-gray-200">
            <th className="border border-gray-300 px-4 py-2">#</th>
            <th className="border border-gray-300 px-4 py-2">
              Un Approved Events
            </th>
            <th className="border border-gray-300 px-4 py-2">Actions</th>
          </tr>
        </thead>
        <tbody>
          {events && events.length > 0 ? (
            events.map((event, index) => (
              <tr key={event._id} className="hover:bg-gray-100">
                <td className="border border-gray-300 px-4 py-2">
                  {index + 1}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  <Link
                    to={`/event/${event._id}`}
                    className="text-blue-500 hover:underline"
                  >
                    {event.event_title}
                  </Link>
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  <button
                    onClick={() =>
                      toggleApproval(event._id, !event.approval_status)
                    }
                    className={`px-3 py-1 rounded ${
                      event.approval_status
                        ? 'bg-green-500 text-white'
                        : 'bg-gray-500 text-white'
                    }`}
                  >
                    {event.approval_status ? 'Approve' : 'Un Approve'}
                  </button>
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={11} className="border border-gray-300 px-4 py-2">
                No unApproved events
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default UnApprovedEvents;
