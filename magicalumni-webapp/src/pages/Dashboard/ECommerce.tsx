import React, { useState, useEffect } from 'react';
import { FaUsers } from 'react-icons/fa';
import { Link } from 'react-router-dom';
import { MdApartment } from 'react-icons/md';
import { MdOutlinePendingActions } from 'react-icons/md';
import { PiSuitcaseSimpleBold } from 'react-icons/pi';
import CardDataStats from '../../components/CardDataStats';
import ChartOne from '../../components/Charts/ChartOne';
import ChartThree from '../../components/Charts/ChartThree';
import ChartTwo from '../../components/Charts/ChartTwo';
import ChatCard from '../../components/Chat/ChatCard';
import MapOne from '../../components/Maps/MapOne';
import TableOne from '../../components/Tables/TableOne';
import './ECommerce.css';

const ECommerce: React.FC = () => {
  const [totalUsers, setTotalUsers] = useState('0');
  const [totalDepartments, setTotalDepartments] = useState('0');
  const [totalUnApprovedMembers, setTotalUnApprovedMembers] = useState('0');
  const [jobCount, setJobCount] = useState('0');
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string>('');
  const collegeId = localStorage.getItem('collegeId');
  if (collegeId) {
    console.log(`College ID: ${collegeId}`);
  } else {
    console.log('No college ID found, please sign in.');
  }
  useEffect(() => {
    const fetchData = async () => {
      try {
        if (!collegeId) {
          setError('No college ID found, please sign in.');
          setLoading(false);
          return;
        }

        const memberResponse = await fetch(
          'http://localhost:3000/api/member/membersCount',
          {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ college_id: collegeId }),
          },
        );

        const memberData = await memberResponse.json();
        if (memberData.status === 'ok') {
          console.log(memberData.memberPeopleCountOff);
          setTotalUsers(memberData.memberPeopleCountOff.toString());
        } else {
          console.error(memberData.message);
        }

        const departmentResponse = await fetch(
          'http://localhost:3000/api/department/departmentCount',
          {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ college_id: collegeId }),
          },
        );

        const departmentData = await departmentResponse.json();
        if (departmentData.status === 'ok') {
          console.log(departmentData.departmentPeopleCountOff);
          setTotalDepartments(
            departmentData.departmentPeopleCountOff.toString(),
          );
        } else {
          console.error(departmentData.message);
        }

        const unApprovedMemberResponse = await fetch(
          'http://localhost:3000/api/member/unApprovedMembersCount',
          {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ college_id: collegeId }),
          },
        );

        const unApprovedMemberData = await unApprovedMemberResponse.json();
        if (unApprovedMemberData.status === 'ok') {
          console.log(unApprovedMemberData.memberPeopleCountOff);
          setTotalUnApprovedMembers(
            unApprovedMemberData.memberPeopleCountOff.toString(),
          );
        } else {
          console.error(unApprovedMemberData.message);
        }

        const jobResponse = await fetch(
          'http://localhost:3000/api/event/unApprovedEventCount',
          {
            method: 'POST',
            headers: {
              'Content-Type': 'application/json',
            },
            body: JSON.stringify({ college_id: collegeId }),
          },
        );

        const jobResponseData = await jobResponse.json();
        if (jobResponseData.status === 'ok') {
          console.log(jobResponseData.eventCountOff);
          setJobCount(jobResponseData.eventCountOff.toString());
        } else {
          console.error(jobResponseData.message);
        }
      } catch (error) {
        console.error('Error fetching data:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, [collegeId]);

  if (loading) {
    return <div>Loading...</div>;
  }

  if (error) {
    return <div>{error}</div>;
  }
  return (
    <>
      <div className="grid grid-cols-1 gap-4 md:grid-cols-2 md:gap-6 xl:grid-cols-4 2xl:gap-7.5">
        <CardDataStats
          title="Total users"
          total={totalUsers}
          rate="0.43%"
          levelUp
        >
          <FaUsers />
        </CardDataStats>
        <CardDataStats
          title="Total Departments"
          total={totalDepartments}
          rate="4.35%"
          levelUp
        >
          <MdApartment />
        </CardDataStats>
        <Link to="/unapproved-members">
          <CardDataStats
            title="Total Unapproved Members"
            total={totalUnApprovedMembers}
            rate="2.59%"
            levelUp
          >
            <MdOutlinePendingActions />
          </CardDataStats>
        </Link>
        <Link to="/unapproved-events">
          <CardDataStats
            title="Total Unapproved Events"
            total={jobCount}
            rate="0.95%"
            levelDown
          >
            <PiSuitcaseSimpleBold />
          </CardDataStats>
        </Link>
      </div>

      <div className="mt-4 grid grid-cols-12 gap-4 md:mt-6 md:gap-6 2xl:mt-7.5 2xl:gap-7.5">
        <ChartOne />
        <ChartTwo />
        <ChartThree />
        <MapOne />
        <div className="col-span-12 xl:col-span-8">
          <TableOne />
        </div>
        <ChatCard />
      </div>
    </>
  );
};

export default ECommerce;
