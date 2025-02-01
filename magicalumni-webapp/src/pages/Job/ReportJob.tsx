import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';

interface Reports {
  _id: string;
  reason: string;
  alumni: string;
  name: string;
}

const ReportJob: React.FC = () => {
  const navigate = useNavigate();
  const { id } = useParams<{ id: string }>();
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  const collegeId = localStorage.getItem('collegeId');
  const [reportJob, setReportJob] = useState<Reports[]>([]);

  useEffect(() => {
    if (collegeId && id) {
      fetchReports();
    } else {
      console.error('No job ID found, cannot fetch reports.');
    }
  }, [collegeId, id]);

  const fetchReports = async () => {
    try {
      const response = await fetch('http://localhost:3000/api/job/reportList', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ college_id: collegeId, job_id: id }),
      });
      const data = await response.json();
      if (data.status === 'ok') {
        setReportJob(data.reportList);
      } else {
        setError(data.message);
      }
    } catch (err) {
      setError('Error fetching reports.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="container mx-auto mt-5">
      <h1 className="text-2xl font-bold mb-4">Reports</h1>
      {loading && <p>Loading...</p>}
      {error && <p className="text-red-500">{error}</p>}
      <button
        className="mt-4 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600"
        onClick={() => navigate(-1)}
      >
        Back
      </button>
      <table className="table-auto w-full border-collapse border border-gray-300 mt-4">
        <thead>
          <tr className="bg-gray-200">
            <th className="border border-gray-300 px-4 py-2">#</th>
            <th className="border border-gray-300 px-4 py-2">Alumni</th>
            <th className="border border-gray-300 px-4 py-2">Reason</th>
          </tr>
        </thead>
        <tbody>
          {reportJob && reportJob.length > 0 ? (
            reportJob.map((reportJobs, index) => (
              <tr key={reportJobs._id} className="hover:bg-gray-100">
                <td className="border border-gray-300 px-4 py-2">
                  {index + 1}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {reportJobs.alumni.name}
                </td>
                <td className="border border-gray-300 px-4 py-2">
                  {reportJobs.reason}
                </td>
              </tr>
            ))
          ) : (
            <tr>
              <td colSpan={2} className="border border-gray-300 px-4 py-2">
                No reports found.
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
};

export default ReportJob;
