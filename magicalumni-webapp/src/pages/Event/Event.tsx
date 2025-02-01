import React, { useEffect, useState } from 'react';
// import ConfirmModal from './ConfirmModal';
import { Link } from 'react-router-dom';

interface Event {
  _id: string;
  alumni_id: string;
  event_title: string;
  event_image: string;
  description: string;
  approval_status: boolean;
  date: string;
  alumni_name: string;
  event_type: string;
  // rsvp_options: string;
  location: string;
  criteria: string;
}

const Events: React.FC = () => {
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  // const [showModal, setShowModal] = useState(false);
  // const [eventIdToDelete, setEventIdToDelete] = useState<string>('');
  const [events, setEvents] = useState<Event[]>([]);
  const collegeId = localStorage.getItem('collegeId');

  useEffect(() => {
    if (collegeId) {
      fetchEvents();
    } else {
      console.error('No college ID found, please sign in.');
    }
  }, []);

  const fetchEvents = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/event/list', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ college_id: collegeId }),
      });
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
            status: status ? 'approved' : 'not approved',
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

  // const handleDelete = async (id: string) => {
  //   setEventIdToDelete(id);
  //   setShowModal(true);
  // };

  // const confirmDelete = async () => {
  //   try {
  //     const response = await fetch(
  //       'http://localhost:3000/api/department/delete',
  //       {
  //         method: 'POST',
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //         body: JSON.stringify({ id: eventIdToDelete }),
  //       },
  //     );

  //     const data = await response.json();

  //     if (data.status === 'ok') {
  //       fetchEvents();
  //       setShowModal(false);
  //     } else {
  //       setError(data.message);
  //     }
  //   } catch (err) {
  //     setError('Error deleting member.');
  //   }
  // };

  // const cancelDelete = () => {
  //   setShowModal(false);
  // };

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
      <h1 className="text-2xl font-bold mb-4">Events</h1>

      {loading && <p>Loading...</p>}
      {error && <p className="text-red-500">{error}</p>}
      <Link
        to="/add-events"
        className="bg-blue-500 text-white px-4 py-2 rounded mb-4 inline-block"
      >
        Add Event
      </Link>
      <table className="table-auto w-full border-collapse border border-gray-300 mt-4">
        <thead>
          <tr className="bg-gray-200">
            <th className="border border-gray-300 px-4 py-2">#</th>
            <th className="border border-gray-300 px-4 py-2">Title</th>
            {/* <th className="border border-gray-300 px-4 py-2">Image</th> */}
            <th className="border border-gray-300 px-4 py-2">Description</th>
            <th className="border border-gray-300 px-4 py-2">Date</th>
            <th className="border border-gray-300 px-4 py-2">Event Type</th>
            {/* <th className="border border-gray-300 px-4 py-2">RSVP Options</th> */}
            <th className="border border-gray-300 px-4 py-2">Location</th>
            <th className="border border-gray-300 px-4 py-2">Criteria</th>
            <th className="border border-gray-300 px-4 py-2">
              Alumni Co-ordinator
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
                  {event.event_title}
                </td>
                {/* <td className="border border-gray-300 px-4 py-2">
                  <img
                    src={event.event_image}
                    alt="Event Thumbnail"
                    className="w-16 h-16 object-cover rounded"
                  />
                </td> */}
                <td className="border border-gray-300 px-4 py-2">
                  {event.description}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {event.date ? formatDate(event.date) : 'N/A'}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {event.event_type}
                </td>
                {/* <td className="border border-gray-300 px-4 py-2">
                  {event.rsvp_options}
                </td> */}
                <td className="border border-gray-300 px-4 py-2">
                  {event.location}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {event.criteria}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {event.alumni_name}
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
                    {event.approval_status ? 'Unapprove' : 'Approve'}
                  </button>
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={11} className="border border-gray-300 px-4 py-2">
                No events available
              </td>
            </tr>
          )}
        </tbody>
      </table>
      {/* <ConfirmModal
        show={showModal}
        onConfirm={confirmDelete}
        onCancel={cancelDelete}
      /> */}
    </div>
  );
};

export default Events;
