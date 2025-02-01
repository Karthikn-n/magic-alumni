import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import './Event.css';

interface Member {
  _id: string;
  name: string;
}

const AddEvent: React.FC = () => {
  const [alumniList, setAlumniList] = useState<Member[]>([]);
  const [cheifGuestList, setCheifGuestList] = useState<Member[]>([]);
  const [eventTitle, setEventTitle] = useState<string>('');
  const [description, setDescription] = useState<string>('');
  const [date, setDate] = useState<string>('');
  //   const [approvalStatus, setApprovalStatus] = useState<string>('approved');
  const [eventType, setEventType] = useState<string>('');
  const [rsvpOptions, setRsvpOptions] = useState<string[]>([
    'yes',
    'no',
    'maybe',
  ]);
  const [location, setLocation] = useState<string>('');
  const [criteria, setCriteria] = useState<string>('');
  const [image, setImage] = useState<File | null>(null);
  const [alumniId, setAlumniId] = useState<string>('');
  const [cheifGuest, setCheifGuest] = useState<string>('');
  const [selectedCheifGuestId, setSelectedCheifGuestId] = useState<string>('');
  const navigate = useNavigate();

  const collegeId = localStorage.getItem('collegeId');

  useEffect(() => {
    if (collegeId) {
      fetchMembers(collegeId);
      fetchCheifGuestList(collegeId);
    }
  }, [collegeId]);

  const fetchMembers = async (collegeId: string) => {
    try {
      const response = await fetch(
        'http://localhost:3000/api/event/coordinatorList',
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
        const alumniMembers = data.alumniList.map((member: any) => ({
          _id: member._id,
          name: member.name,
        }));
        setAlumniList(alumniMembers);
      } else {
        alert(data.message);
      }
    } catch (err) {
      console.error('Error fetching alumni:', err);
    }
  };

  const fetchCheifGuestList = async (collegeId: string) => {
    try {
      const response = await fetch(
        'http://localhost:3000/api/member/allMembers',
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
        setCheifGuestList(
          data.alumniDetails.map((member: any) => ({
            _id: member._id,
            name: member.name,
          })),
        );
      } else {
        alert(data.message);
      }
    } catch (err) {
      console.error('Error fetching chief guest list:', err);
    }
  };

  const handleImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setImage(file);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    if (!alumniId || !collegeId || !eventTitle || !date || !image) {
      alert('Please fill in all required fields.');
      return;
    }

    const formData = new FormData();
    formData.append('alumni_id', alumniId);
    formData.append('college_id', collegeId);
    formData.append('event_title', eventTitle);
    formData.append('description', description);
    formData.append('date', date);
    // formData.append('approval_status', approvalStatus);
    formData.append('event_type', eventType);
    // formData.append('rsvp_options', JSON.stringify(rsvpOptions));
    formData.append('location', location);
    formData.append('criteria', criteria);
    formData.append('event_image', image);
    formData.append('cheif_guest', cheifGuest);

    try {
      const response = await fetch('http://localhost:3000/api/event/create', {
        method: 'POST',
        body: formData,
      });
      const data = await response.json();

      if (data.status === 'ok') {
        alert('Event created successfully!');
        navigate('/events');
      } else {
        alert(data.message);
      }
    } catch (error) {
      console.error('Error creating event:', error);
      alert('An error occurred while creating the event.');
    }
  };

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Create Event</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label htmlFor="alumni_id" className="block text-sm font-medium">
            Alumni
          </label>
          <select
            id="alumni_id"
            value={alumniId}
            onChange={(e) => setAlumniId(e.target.value)}
            className="block w-full p-2 border border-gray-300 rounded"
          >
            <option value="">Select Alumni</option>
            {alumniList.map((alumni) => (
              <option key={alumni._id} value={alumni._id}>
                {alumni.name}
              </option>
            ))}
          </select>
        </div>

        <div>
          <label htmlFor="event_title" className="block text-sm font-medium">
            Event Title
          </label>
          <input
            type="text"
            id="event_title"
            value={eventTitle}
            onChange={(e) => setEventTitle(e.target.value)}
            className="block w-full p-2 border border-gray-300 rounded"
            required
          />
        </div>

        <div>
          <label htmlFor="description" className="block text-sm font-medium">
            Event Description
          </label>
          <textarea
            id="description"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            className="block w-full p-2 border border-gray-300 rounded"
            required
          />
        </div>

        <div>
          <label htmlFor="date" className="block text-sm font-medium">
            Event Date
          </label>
          <input
            type="date"
            id="date"
            value={date}
            onChange={(e) => setDate(e.target.value)}
            className="block w-full p-2 border border-gray-300 rounded"
            required
          />
        </div>
        <div>
          <label htmlFor="event_type" className="block text-sm font-medium">
            Event Type
          </label>
          <input
            type="text"
            id="event_type"
            value={eventType}
            onChange={(e) => setEventType(e.target.value)}
            className="block w-full p-2 border border-gray-300 rounded"
            required
          />
        </div>
        {/* <div>
          <label htmlFor="rsvp_options" className="block text-sm font-medium">
            RSVP Options
          </label>
          <select
            id="rsvp_options"
            value={rsvpOptions[0]}
            onChange={(e) => setRsvpOptions([e.target.value])}
            className="block w-full p-2 border border-gray-300 rounded"
          >
            <option value="yes">Yes</option>
            <option value="no">No</option>
            <option value="maybe">Maybe</option>
          </select>
        </div> */}

        <div>
          <label htmlFor="location" className="block text-sm font-medium">
            Event Location
          </label>
          <input
            type="text"
            id="location"
            value={location}
            onChange={(e) => setLocation(e.target.value)}
            className="block w-full p-2 border border-gray-300 rounded"
          />
        </div>

        <div>
          <label htmlFor="criteria" className="block text-sm font-medium">
            Event Criteria
          </label>
          <input
            type="text"
            id="criteria"
            value={criteria}
            onChange={(e) => setCriteria(e.target.value)}
            className="block w-full p-2 border border-gray-300 rounded"
          />
        </div>
        {/* <div>
          <label htmlFor="cheif_guest" className="block text-sm font-medium">
            Chief Guest
          </label>
          <input
            type="text"
            id="cheif_guest"
            value={cheifGuest}
            onChange={(e) => {
              setCheifGuest(e.target.value);
              // setSelectedCheifGuest('');
            }}
            className="block w-full p-2 border border-gray-300 rounded"
            placeholder="Enter Chief Guest name or select from dropdown"
          />
        </div> */}

        <div>
          <label className="block text-sm font-medium">Chief Guest</label>
          <input
            type="text"
            value={cheifGuest}
            onChange={(e) => {
              setCheifGuest(e.target.value);
              setSelectedCheifGuestId('');
            }}
            className="block w-full p-2 border border-gray-300 rounded"
            placeholder="Enter Chief Guest name"
            disabled={!!selectedCheifGuestId}
          />
          <select
            value={selectedCheifGuestId}
            onChange={(e) => {
              setSelectedCheifGuestId(e.target.value);
              setCheifGuest('');
            }}
            className="block w-full p-2 border border-gray-300 rounded mt-2"
            disabled={!!cheifGuest}
          >
            <option value="">Select Chief Guest from Alumni</option>
            {cheifGuestList.map((alumni) => (
              <option key={alumni._id} value={alumni._id}>
                {alumni.name}
              </option>
            ))}
          </select>
        </div>
        <div>
          <label htmlFor="event_image" className="block text-sm font-medium">
            Event Image
          </label>
          <input
            type="file"
            id="event_image"
            onChange={handleImageChange}
            className="block w-full p-2 border border-gray-300 rounded"
            required
          />
        </div>

        <button
          type="submit"
          className="bg-blue-500 text-white px-4 py-2 rounded"
        >
          Create Event
        </button>
      </form>
    </div>
  );
};

export default AddEvent;
