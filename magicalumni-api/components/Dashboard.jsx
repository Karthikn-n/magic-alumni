import React from "react";
import { Box, H1, Text, Link } from "@adminjs/design-system";

const Dashboard = () => {
  return (
    <Box>
      <H1>Welcome to the Admin Panel</H1>
      <Text>Navigate to:</Text>
      <Link href="/admin/pages/Reports">Reports</Link>
      <br />
      <Link href="/admin/pages/Settings">Settings</Link>
    </Box>
  );
};

export default Dashboard;
