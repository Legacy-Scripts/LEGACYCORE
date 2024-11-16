import React, { useState } from "react";
import {
  Grid,
  Col,
  Card,
  Text,
  Title,
  Container,
  Progress,
  ThemeIcon,
  Button,
  Select,
  TextInput,
} from "@mantine/core";
import {
  IconCoin,
  IconRipple,
  IconCurrencyBitcoin,
  IconArrowBarToDown,
  IconContainer,
} from "@tabler/icons-react";
import { motion } from "framer-motion";

const mockData = [
  {
    name: "Bytecoin",
    symbol: "BYT",
    price: "$1,200",
    change: 5.2,
    icon: <IconCoin size={30} color="white" />,
    marketCap: "$300 Million",
    volume: "$12 Million",
  },
  {
    name: "TechToken",
    symbol: "TKN",
    price: "$75",
    change: -2.3,
    icon: <IconCoin size={30} color="white" />,
    marketCap: "$120 Million",
    volume: "$8 Million",
  },
  {
    name: "InnoCoin",
    symbol: "INC",
    price: "$15",
    change: 0.9,
    icon: <IconCoin size={30} color="white" />,
    marketCap: "$50 Million",
    volume: "$1 Million",
  },
  {
    name: "RippleX",
    symbol: "RPX",
    price: "$3.20",
    change: 1.7,
    icon: <IconRipple size={30} color="white" />,
    marketCap: "$85 Million",
    volume: "$3 Million",
  },
];

const Crypto: React.FC = () => {
  const [selectedCrypto, setSelectedCrypto] = useState<string | null>(mockData[0].symbol);
  const [balance, setBalance] = useState<number>(0); 
  const selectedData = mockData.find(crypto => crypto.symbol === selectedCrypto);

  return (
    <Container>
      <Title order={3} align="center" style={{ marginBottom: "5px", color: "#fff" }}>
        Mock Cryptocurrency Dashboard
      </Title>
      <Text mb={30} align="center" size="sm" color="dimmed">
        Track fictional crypto assets
      </Text>
      <Grid gutter="md">
        {mockData.map((crypto, index) => (
          <Col span={6} key={index}>
            <motion.div
              initial={{ opacity: 0, translateY: 20 }}
              animate={{ opacity: 1, translateY: 0 }}
              transition={{ duration: 0.5, delay: index * 0.1 }}
            >
              <Card
                padding="lg"
                withBorder
                shadow="md"
                style={{
                  background: `transparent`,
                  color: "#fff",
                  height: "160px",
                  position: "relative",
                  overflow: "hidden",
                }}
              >
                <Card.Section
                  style={{
                    padding: "15px",
                    display: "flex",
                    alignItems: "center",
                    justifyContent: "space-between",
                    borderBottom: "1px solid rgba(255, 255, 255, 0.1)",
                  }}
                >
                  <div style={{ display: "flex", alignItems: "center" }}>
                    <ThemeIcon size={40} variant="light" color="blue" style={{ marginRight: "10px" }}>
                      {crypto.icon}
                    </ThemeIcon>
                    <div>
                      <Text size="lg" weight={500}>
                        {crypto.name} ({crypto.symbol})
                      </Text>
                      <Text size="sm" color="dimmed">
                        {crypto.price}
                      </Text>
                    </div>
                  </div>
                  <div style={{ textAlign: "right", color: "dimmed" }}>
                    <Text size="sm">{crypto.marketCap}</Text>
                    <Text size="sm">{crypto.volume}</Text>
                  </div>
                </Card.Section>

                <Card.Section
                  style={{
                    padding: "15px",
                    display: "flex",
                    flexDirection: "column",
                  }}
                >
                  <Text size="sm" color="dimmed" style={{ marginBottom: "5px" }}>
                    24h Change:
                  </Text>
                  <div style={{ display: "flex", alignItems: "center" }}>
                    <Text
                      size="lg"
                      weight={700}
                      color={crypto.change >= 0 ? "green" : "red"}
                      style={{ marginRight: "10px" }}
                    >
                      {crypto.change >= 0 ? `+${crypto.change}%` : `${crypto.change}%`}
                    </Text>
                    <Progress
                      value={Math.max(Math.abs(crypto.change), 1)} 
                      color={crypto.change >= 0 ? "green" : "red"}
                      size="sm"
                      style={{ flex: 1 }}
                    />
                  </div>
                </Card.Section>
              </Card>
            </motion.div>
          </Col>
        ))}

        <Col span={12}>
          <motion.div
            initial={{ opacity: 0, translateY: 20 }}
            animate={{ opacity: 1, translateY: 0 }}
            transition={{ duration: 0.5 }}
          >
            <Card
              padding="md"
              withBorder
              shadow="md"
              style={{
                background: "transparent",
                color: "#fff",
                height: "auto",
              }}
            >
              <div style={{ padding: "10px", display: "flex", justifyContent: "space-between", alignItems: "flex-start" }}>
                <div>
                  <Text size="md" weight={600}>
                    Cryptocurrency Info
                  </Text>
                  <Text size="xs" color="dimmed" style={{ marginTop: "2px" }}>
                    Select a cryptocurrency to view details
                  </Text>
                </div>
                
 
                <Select
                  data={mockData.map(crypto => ({ value: crypto.symbol, label: `${crypto.name} (${crypto.symbol})` }))}
                  value={selectedCrypto}
                  onChange={setSelectedCrypto}
                  placeholder="Select a cryptocurrency"
                  style={{ marginBottom: "10px", width: "200px" }}
                />
              </div>

              {selectedData ? (
                <div style={{ display: "flex", alignItems: "center", marginTop: "10px" }}>
                  <ThemeIcon size={40} variant="light" color="blue" style={{ marginRight: "10px" }}>
                    {selectedData.icon}
                  </ThemeIcon>
                  <div style={{ display: "flex", alignItems: "baseline" }}>
                    <Text size="lg" weight={500}>
                      {selectedData.name} ({selectedData.symbol})
                    </Text>
                    <Text size="lg" weight={500} style={{ marginLeft: "10px", color: "dimmed" }}>
                      {selectedData.price}
                    </Text>
                  </div>
                  <TextInput
                    value={balance.toString()}
                    onChange={(event) => setBalance(Number(event.currentTarget.value))}
                    placeholder="Enter your balance"
                    style={{ marginLeft: "20px", width: "150px" }}
                    type="number"
                    label="Your Balance"
                  />
                </div>
              ) : (
                <Text size="sm" color="red">
                  Cryptocurrency data not found.
                </Text>
              )}

              {selectedData && (
                <div style={{ display: "flex", alignItems: "center" }}>
                  <Text
                    size="lg"
                    weight={700}
                    color={selectedData.change >= 0 ? "green" : "red"}
                    style={{ marginRight: "10px" }}
                  >
                    {selectedData.change >= 0
                      ? `+${selectedData.change}%`
                      : `${selectedData.change}%`}
                  </Text>
                  <Progress
                    value={Math.max(Math.abs(selectedData.change), 1)} 
                    color={selectedData.change >= 0 ? "green" : "red"}
                    size="sm"
                    style={{ flex: 1 }}
                  />
                </div>
              )}

              <div style={{ marginTop: "10px", display: "flex", justifyContent: "flex-end", padding: "0 10px" }}>
                <Button
                  leftIcon={<IconContainer size={14} />}
                  color="blue"
                  variant="outline"
                  compact
                  style={{ fontSize: "0.75rem", padding: "5px 8px" }}
                >
                  Mine
                </Button>
                <Button
                  leftIcon={<IconArrowBarToDown size={14} />}
                  color="green"
                  variant="filled"
                  compact
                  style={{ fontSize: "0.75rem", padding: "5px 8px" }}
                >
                  Withdraw
                </Button>
              </div>
            </Card>
          </motion.div>
        </Col>
      </Grid>
    </Container>
  );
};

export default Crypto;
