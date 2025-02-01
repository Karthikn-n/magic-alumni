import { useState, useEffect } from 'react';
import Breadcrumb from '../components/Breadcrumbs/Breadcrumb';

interface Event {
  date: string;
  event_title: string;
}

const Calendar = () => {
  const [currentDate, setCurrentDate] = useState(new Date());
  const [events, setEvents] = useState<Event[]>([]);

  const college_id = localStorage.getItem('collegeId');

  useEffect(() => {
    if (college_id) {
      const fetchEvents = async () => {
        try {
          console.log('Fetching events for college ID:', college_id);
          const response = await fetch('http://localhost:3000/api/event/list', {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ college_id: college_id }),
          });
          console.log('API response:', response);

          const data = await response.json();
          console.log('Parsed response data:', data);

          if (data.status === 'ok') {
            setEvents(data.eventList);
            console.log('Fetched events:', data.eventList);
          } else {
            console.error('No events found for this college');
          }
        } catch (error) {
          console.error('Error fetching events:', error);
        }
      };

      fetchEvents();
    }
  }, [college_id]);

  const year = currentDate.getFullYear();
  const month = currentDate.getMonth();
  const firstDayOfMonth = new Date(year, month, 1).getDay();
  const daysInMonth = new Date(year, month + 1, 0).getDate();

  const handlePrevMonth = () => {
    setCurrentDate(new Date(year, month - 1, 1));
  };

  const handleNextMonth = () => {
    setCurrentDate(new Date(year, month + 1, 1));
  };

  const getEventForDate = (day: number): Event | undefined => {
    if (!Array.isArray(events) || events.length === 0) {
      return undefined;
    }

    const calendarDate = new Date(year, month, day);
    calendarDate.setHours(0, 0, 0, 0);

    return events.find((event) => {
      const eventDate = new Date(event.date);
      eventDate.setHours(0, 0, 0, 0);

      return eventDate.getTime() === calendarDate.getTime();
    });
  };

  return (
    <>
      <Breadcrumb pageName="Calendar" />
      <div className="w-full max-w-full rounded-sm border border-stroke bg-white shadow-default dark:border-strokedark dark:bg-boxdark">
        <div className="flex justify-between p-4">
          <button
            onClick={handlePrevMonth}
            className="px-4 py-2 bg-gray-200 dark:bg-meta-4 rounded"
          >
            Previous
          </button>
          <span className="text-xl font-semibold">
            {`${currentDate.toLocaleString('default', {
              month: 'long',
            })} ${year}`}
          </span>
          <button
            onClick={handleNextMonth}
            className="px-4 py-2 bg-gray-200 dark:bg-meta-4 rounded"
          >
            Next
          </button>
        </div>

        <table className="w-full">
          <thead>
            <tr className="grid grid-cols-7 bg-primary text-white">
              {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) => (
                <th key={day} className="p-2 text-center">
                  {day}
                </th>
              ))}
            </tr>
          </thead>
          <tbody>
            {[...Array(6)].map((_, weekIdx) => (
              <tr key={weekIdx} className="grid grid-cols-7">
                {[...Array(7)].map((_, dayIdx) => {
                  const day = weekIdx * 7 + dayIdx - firstDayOfMonth + 1;
                  const isValidDay = day > 0 && day <= daysInMonth;
                  const event = isValidDay ? getEventForDate(day) : undefined;
                  const isToday =
                    isValidDay &&
                    day === currentDate.getDate() &&
                    month === currentDate.getMonth() &&
                    year === currentDate.getFullYear();

                  return (
                    <td
                      key={dayIdx}
                      className={`relative h-20 border p-2 hover:bg-gray dark:border-strokedark dark:hover:bg-meta-4 ${
                        isToday ? 'bg-blue-200 dark:bg-blue-600' : ''
                      }`}
                    >
                      {isValidDay && (
                        <span
                          className={`text-black dark:text-white ${
                            isToday ? 'font-bold' : ''
                          }`}
                        >
                          {day}
                        </span>
                      )}
                      {event && (
                        <div
                          className="absolute top-8 left-2 w-full bg-blue-200 p-1 rounded text-xs"
                          style={{ width: '125px' }}
                        >
                          {event.event_title}
                        </div>
                      )}
                    </td>
                  );
                })}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
};

export default Calendar;
