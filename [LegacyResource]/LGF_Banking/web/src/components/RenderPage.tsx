import React, { useEffect, useState } from "react";
import {
  Avatar,
  Group,
  UnstyledButton,
  Text,
  Title,
  Box,
  Divider,
  Flex,
} from "@mantine/core";
import {
  IconHome,
  IconSettings,
  IconLock,
  IconCurrencyDollar,
  IconMapPin,
  IconLogout,
  IconClock,
} from "@tabler/icons-react";
import Dashboard from "./Dashboard";
import SettingsPin from "./SettingsPin";
import Invoice from "./Invoice";
import Crypto from "./Crypto";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";

const Menu: React.FC<{ visible: boolean; playerData: any }> = ({ visible, playerData }) => {
  const [activeTab, setActiveTab] = useState<string | null>("dashboard");
  const [hoveredTab, setHoveredTab] = useState<string | null>(null);
  const [playerAmountBank , setPlayerAmountBank] = useState(playerData.amountBank);

  const [currentTime, setCurrentTime] = useState("");

  useEffect(() => {
    if (visible) {
      const updateTime = () => {
        const now = new Date();
        const options: Intl.DateTimeFormatOptions = { 
          hour: "2-digit", 
          minute: "2-digit", 
          second: "2-digit" 
        };
        setCurrentTime(now.toLocaleTimeString([], options)); 
      };
  
      updateTime(); 
      const intervalId = setInterval(updateTime, 1000);
  
      return () => clearInterval(intervalId); 
    }

  }, [visible]);

  const fetchLogout = async () => {
    try {
      fetchNui('LGF_Banking:CloseByIndex', { ui_name: "openBanking" });
    } catch (error) {
      console.error('Error during logout:', error);
    }
  };

  useNuiEvent<number>("updateMoney", (soldi) => {
    setPlayerAmountBank(soldi)
    console.log(soldi)
  });

  const tabStyle = {
    display: "flex",
    alignItems: "center",
    gap: "10px",
    padding: "10px 12px",
    borderRadius: "8px",
    transition: "background-color 0.3s ease",
    color: "#ccc",
  };

  const hoverStyle = {
    backgroundColor: "#475569",
    color: "#fff",
  };

  const activeStyle = {
    backgroundColor: "#475569",
    color: "#fff",
  };

  return (
    <div
      className={`banking-menu ${visible ? "slide-in" : "slide-out"}`}
      style={{ display: "flex" }}
    >
      <Group position="apart" mb="lg">
        <Group>
          <Avatar size="lg" src="https://avatars.githubusercontent.com/u/145626625?v=4" alt="User Avatar" />
          <Divider color="gray" size="xs" orientation="vertical" />
          <div>
            <Title order={2} style={{ color: "#fff" }}>
              Hi {playerData?.PlayerName}
            </Title>
          </div>
        </Group>

        <Box
          sx={{
            display: "flex",
            alignItems: "center",
            backgroundColor: "#020617",
            padding: "8px 12px",
            borderRadius: "8px",
            gap: "15px",
            marginRight: "15px",
            border: "1px solid rgba(255, 255, 255, 0.1)",
          }}
        >
          <Flex align="center" style={{ gap: "5px", color: "#ccc" }}>
            <IconMapPin size={30} color="#475569" />
            <Text tt="uppercase" size="sm" color="white">
              {playerData?.Location}
            </Text>
          </Flex>

          <Flex align="center" style={{ gap: "5px", color: "#ccc" }}>
            <IconCurrencyDollar size={30} color="#064e3b" />
            <Text tt="uppercase" size="sm" color="white">
              {playerAmountBank}
            </Text>
          </Flex>

          <Flex align="center" style={{ gap: "5px", color: "#ccc" }}>
            <IconClock stroke={2} size={28} color="gray" /> 
            <Text tt="uppercase" size="sm" color="white">
              {currentTime}
            </Text>
          </Flex>
        </Box>
      </Group>

      <div style={{ display: "flex" }}>
        <div
          style={{
            display: "flex",
            flexDirection: "column",
            gap: "10px",
            width: "170px",
          }}
        >
          <UnstyledButton
            onClick={() => setActiveTab("dashboard")}
            onMouseEnter={() => setHoveredTab("dashboard")}
            onMouseLeave={() => setHoveredTab(null)}
            style={{
              ...tabStyle,
              ...(activeTab === "dashboard" ? activeStyle : (hoveredTab === "dashboard" ? hoverStyle : {})),
            }}
          >
            <IconHome size={18} />
            <span>Dashboard</span>
          </UnstyledButton>

          <UnstyledButton
            onClick={() => setActiveTab("settingsPin")}
            onMouseEnter={() => setHoveredTab("settingsPin")}
            onMouseLeave={() => setHoveredTab(null)}
            style={{
              ...tabStyle,
              ...(activeTab === "settingsPin" ? activeStyle : (hoveredTab === "settingsPin" ? hoverStyle : {})),
            }}
          >
            <IconLock size={18} />
            <span>Settings Pin</span>
          </UnstyledButton>

          <UnstyledButton
            onClick={() => setActiveTab("invoice")}
            onMouseEnter={() => setHoveredTab("invoice")}
            onMouseLeave={() => setHoveredTab(null)}
            style={{
              ...tabStyle,
              ...(activeTab === "invoice" ? activeStyle : (hoveredTab === "invoice" ? hoverStyle : {})),
            }}
          >
            <IconSettings size={18} />
            <span>Invoice</span>
          </UnstyledButton>
        </div>




        <div style={{ flexGrow: 1 }}>
          {activeTab === "dashboard" && <Dashboard visible={visible} playerData={playerData} />}
          {activeTab === "settingsPin" && <SettingsPin visible={visible} />}
          {activeTab === "crypto" && <Crypto />}
          {activeTab === "invoice" && <Invoice visible={visible} playerData={playerData} />}
        </div>
      </div>

      <div style={{ marginTop: "auto", padding: "20px 0" }}>
        <UnstyledButton
          onClick={fetchLogout}
          style={{
            ...tabStyle,
            ...hoverStyle,
            position: "absolute",
            bottom: "25px",
            left: "50px",
            backgroundColor: "",
            borderRadius: "4px",
          }}
          onMouseEnter={(e) =>
            (e.currentTarget.style.backgroundColor = "#475569")
          }
          onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = "")}
        >
          <IconLogout
            style={{
              color: "#b91c1c",
            }}
            size={30}
          />
          <Text tt="uppercase" size="sm" color="dimmed">
            Logout
          </Text>
        </UnstyledButton>
      </div>
    </div>
  );
};

export default Menu;
