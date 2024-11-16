import React, { useEffect, useMemo, useState } from "react";
import {
  Grid,
  Col,
  Card,
  Text,
  Title,
  Group,
  Container,
  Button,
  TextInput,
  List,
  Badge,
  ScrollArea,
  ThemeIcon,
  ActionIcon,
  Tooltip as Tooltipmantine,
} from "@mantine/core";
import {
  IconCurrencyDollar,
  IconArrowDown,
  IconExchange,
  IconChartLine,
  IconClock,
  IconPlus,
  IconMinus,
  IconNumber,
  IconTrash,
} from "@tabler/icons-react";
import {
  LineChart,
  Line,
  XAxis,
  YAxis,
  Tooltip,
  ResponsiveContainer,
  CartesianGrid,
} from "recharts";
import { fetchNui } from "../utils/fetchNui";
import { motion } from "framer-motion";
import { useNuiEvent } from "../hooks/useNuiEvent";

interface Transaction {
  id: number;
  amount: number;
  type: "Deposit" | "Withdraw" | "Transferred";
  dateTime: string;
}

const Dashboard: React.FC<{ visible: boolean; playerData: any }> = ({
  visible,
  playerData,
}) => {
  const [balance, setBalance] = useState(13066);
  const [depositAmount, setDepositAmount] = useState("");
  const [withdrawAmount, setWithdrawAmount] = useState("");
  const [transferAmount, setTransferAmount] = useState("");
  const [playerId, setPlayerId] = useState("");
  const [recentTransactions, setRecentTransactions] = useState<Transaction[]>(
    []
  );

  const handleWithdraw = () => {
    const amountNum = parseFloat(withdrawAmount);
    if (amountNum > 0) {
      setBalance((prev) => prev - amountNum);
      setWithdrawAmount("");
      fetchNui("LGF_Banking.ManageActionAccount", {
        Action: "withdraw",
        Amount: amountNum,
      });
    }
  };

  const handleDeposit = () => {
    const amountNum = parseFloat(depositAmount);
    if (amountNum > 0) {
      setBalance((prev) => prev + amountNum);
      setDepositAmount("");
      fetchNui("LGF_Banking.ManageActionAccount", {
        Action: "deposit",
        Amount: amountNum,
      });
    }
  };

  const handleTransfer = () => {
    const amountNum = parseFloat(transferAmount);
    if (amountNum > 0 && playerId) {
      fetchNui("LGF_Banking.ManageActionAccount", {
        Action: "transfered",
        Amount: amountNum,
        PlayerID: playerId,
      });
      setTransferAmount("");
      setPlayerId("");
    } else {
      console.log("Please enter a valid amount and player ID!");
    }
  };

  const fetchAllTransactions = async () => {
    try {
      const allTransactions = (await fetchNui("LGF_Banking.GetAllTransaction" )) as Transaction[];
      setRecentTransactions(allTransactions);
    } catch (error) {
      console.error("Failed to fetch transactions:", error);
    }
  };

  const ClearAllTransactions = async () => {
    await fetchNui("LGF_Banking.ClearAllTransactions");
    setTimeout(() => {
      fetchAllTransactions();
    }, 1000);
  };


  useNuiEvent<any>("updateTransactions", () => {
    fetchAllTransactions();
    console.log("diocane update")
  });


  const calculateDailyTotals = useMemo(() => {
    const dailyTotals: Record<
      string,
      { deposits: number; withdrawals: number; transfers: number }
    > = {};

    recentTransactions.forEach((transaction) => {
      const date = transaction.dateTime.split("T")[0]; 

      if (!dailyTotals[date]) {
        dailyTotals[date] = { deposits: 0, withdrawals: 0, transfers: 0 };
      }

      if (transaction.type === "Deposit") {
        dailyTotals[date].deposits += transaction.amount;
      } else if (transaction.type === "Withdraw") {
        dailyTotals[date].withdrawals += transaction.amount;
      } else if (transaction.type === "Transferred") {
        dailyTotals[date].transfers += transaction.amount;
      }
    });

    return Object.entries(dailyTotals).map(([date, totals]) => ({
      date,
      deposits: totals.deposits  || 0,
      withdrawals: totals.withdrawals  || 0,
      transfers: totals.transfers || 0,
    }));
  }, [recentTransactions]);

  useEffect(() => {
    if (visible) {
      fetchAllTransactions();
    }
  }, [visible]);

  return (
    <Container p={0} w={900}>
      <Grid gutter="md">
        {/* Card: Deposit */}
        <Col span={4}>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8 }}
          >
            <Card
              padding="lg"
              withBorder
              shadow="sm"
              style={{
                backgroundColor: "#020617",
                color: "#fff",
                height: "195px",
              }}
            >
              <Card.Section style={{ padding: "20px" }}>
                <Group position="apart">
                  <div>
                    <Title tt="uppercase" order={4}>
                      Deposit
                    </Title>
                    <Text size="xs" color="dimmed">
                      Deposit funds in your wallet
                    </Text>
                  </div>
                  <ThemeIcon size={40} variant="outline" color="indigo">
                    <IconCurrencyDollar size={30} stroke={1} />
                  </ThemeIcon>
                </Group>
              </Card.Section>
              <Card.Section style={{ padding: "20px" }}>
                <TextInput
                  icon={<IconPlus size={16} />} 
                  placeholder="Amount"
                  value={depositAmount}
                  onChange={(e) => setDepositAmount(e.currentTarget.value)}
                  style={{ marginBottom: "10px" }}
                  styles={{
                    input: {
                      color: "#fff",
                      background: `rgba(255, 255, 255, 0.1)`,
                      border: "none",
                    },
                  }}
                />
                <Button
                  variant="light"
                  compact
                  onClick={handleDeposit}
                  color="indigo"
                  fullWidth
                >
                  Deposit
                </Button>
              </Card.Section>
            </Card>
          </motion.div>
        </Col>

        {/* Card: Withdraw */}
        <Col span={4}>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8 }}
          >
            <Card
              padding="lg"
              shadow="sm"
              withBorder
              style={{
                backgroundColor: "#020617",
                color: "#fff",
                height: "195px",
              }}
            >
              <Card.Section style={{ padding: "20px" }}>
                <Group position="apart">
                  <div>
                    <Title tt="uppercase" order={4}>
                      Withdraw
                    </Title>
                    <Text size="xs" color="dimmed">
                      Withdraw funds from your wallet
                    </Text>
                  </div>
                  <ThemeIcon size={40} variant="outline" color="green">
                    <IconArrowDown size={30} stroke={1} />
                  </ThemeIcon>
                </Group>
              </Card.Section>
              <Card.Section style={{ padding: "20px" }}>
                <TextInput
                  icon={<IconMinus size={16} />} 
                  placeholder="Amount"
                  value={withdrawAmount}
                  onChange={(e) => setWithdrawAmount(e.currentTarget.value)}
                  style={{ marginBottom: "10px" }}
                  styles={{
                    input: {
                      color: "#fff",
                      background: `rgba(255, 255, 255, 0.1)`,
                      border: "none",
                    },
                  }}
                />
                <Button
                  variant="light"
                  compact
                  onClick={handleWithdraw}
                  color="green"
                  fullWidth
                >
                  Withdraw
                </Button>
              </Card.Section>
            </Card>
          </motion.div>
        </Col>

        {/* Card: Transfer Money */}
        <Col span={4}>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8 }}
          >
            <Card
              padding="lg"
              shadow="sm"
              withBorder
              style={{
                backgroundColor: "#020617",
                color: "#fff",
                height: "195px",
              }}
            >
              <Card.Section style={{ padding: "20px" }}>
                <Group position="apart">
                  <div>
                    <Title tt="uppercase" order={4}>
                      Transfer
                    </Title>
                    <Text size="xs" color="dimmed">
                      Transfer funds to another player
                    </Text>
                  </div>
                  <ThemeIcon size={40} variant="outline" color="yellow">
                    <IconExchange size={30} stroke={1} />
                  </ThemeIcon>
                </Group>
              </Card.Section>
              <Card.Section style={{ padding: "20px" }}>
                <Grid>
                  <Col span={6}>
                    <TextInput
                      icon={<IconCurrencyDollar size={16} />} 
                      placeholder="Amount"
                      value={transferAmount}
                      onChange={(e) => setTransferAmount(e.currentTarget.value)}
                      style={{ marginBottom: "10px" }}
                      styles={{
                        input: {
                          color: "#fff",
                          background: `rgba(255, 255, 255, 0.1)`,
                          border: "none",
                        },
                      }}
                    />
                  </Col>
                  <Col span={6}>
                    <TextInput
                      placeholder="Player ID"
                      value={playerId}
                      icon={<IconNumber size={16} />}
                      onChange={(e) => setPlayerId(e.currentTarget.value)}
                      style={{ marginBottom: "10px" }}
                      styles={{
                        input: {
                          color: "#fff",
                          background: `rgba(255, 255, 255, 0.1)`,
                          border: "none",
                        },
                      }}
                    />
                  </Col>
                </Grid>
                <Button
                  variant="light"
                  compact
                  onClick={handleTransfer}
                  color="yellow"
                  fullWidth
                >
                  Transfer
                </Button>
              </Card.Section>
            </Card>
          </motion.div>
        </Col>

 
        <Col span={6}>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8 }}
          >
            <Card
              padding="lg"
              withBorder
              shadow="sm"
              style={{
                backgroundColor: "#020617",
                color: "#fff",
                height: "350px",
              }}
            >
              <Card.Section style={{ padding: "20px" }}>
                <Group position="apart">
                  <div>
                    <Title tt="uppercase" order={4}>
                      Transaction Chart
                    </Title>
                    <Text size="sm" color="dimmed">
                      Visualize your transaction trends
                    </Text>
                  </div>
                  <ThemeIcon size={40} variant="outline" color="red">
                    <IconChartLine size={30} stroke={1} />
                  </ThemeIcon>
                </Group>
              </Card.Section>
              <Card.Section style={{ width: "390px", height: "250px" }}>
                <ResponsiveContainer width="100%" height="100%">
                  <LineChart data={calculateDailyTotals}>
                    <CartesianGrid strokeDasharray="3 3" stroke="#444" />{" "}
               
                    <XAxis dataKey="date" tick={{ fill: "#ccc" }} />{" "}
            
                    <YAxis tick={{ fill: "#ccc" }} />
                    <Tooltip
                      contentStyle={{
                        backgroundColor: "#333",
                        borderColor: "#333",
                      }}
                      labelStyle={{ color: "#fff" }}
                      itemStyle={{ color: "#ddd" }}
                    />
                    <Line
                      type="monotone"
                      dataKey="deposits"
                      stroke="#4caf50"
                      name="Deposits"
                      strokeWidth={1.5}
                      dot={{ r: 3 }}
                    />
                    <Line
                      type="monotone"
                      dataKey="withdrawals"
                      stroke="#f44336"
                      name="Withdrawals"
                      strokeWidth={1.5}
                      dot={{ r: 3 }}
                    />
                    <Line
                      type="monotone"
                      dataKey="transfers"
                      stroke="#ffc107"
                      name="Transfers"
                      strokeWidth={1.5}
                      dot={{ r: 3 }}
                    />
                  </LineChart>
                </ResponsiveContainer>
              </Card.Section>
            </Card>
          </motion.div>
        </Col>


        <Col span={6}>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            transition={{ duration: 0.8 }}
          >
            <Card
              padding="lg"
              withBorder
              shadow="sm"
              style={{
                backgroundColor: "#020617",
                color: "#fff",
                height: "350px",
              }}
            >
              <Card.Section style={{ padding: "20px" }}>
                <Group position="apart">
                  <div>
                    <Title tt="uppercase" order={4}>
                      Recent Transactions
                    </Title>
                    <Text size="sm" color="dimmed">
                      Overview of recent activities
                    </Text>
                  </div>

                  <Group spacing="xs" position="right">
                    <ThemeIcon size={40} variant="outline" color="violet">
                      <IconClock size={30} stroke={1} />
                    </ThemeIcon>
                   <Tooltipmantine
                      withinPortal
                      position="right-end"
                      color="gray"
                      label="Clear Transactions"
                    >
                      <ActionIcon
                        onClick={ClearAllTransactions}
                        size={40}
                        color="red"
                        variant="outline"
                      >
                        <IconTrash stroke={1} size={30} />
                      </ActionIcon>
                    </Tooltipmantine> 
                  </Group>
                </Group>
              </Card.Section>
              <Card.Section style={{ padding: "20px", height: "230px" }}>
                <ScrollArea style={{ height: "223px" }}>
                  <List spacing="xs" size="sm" center>
                    {recentTransactions.map((transaction) => (
                      <List.Item
                        key={transaction.id}
                        icon={
                          <Badge
                            variant="dot"
                            radius="sm"
                            size="md"
                            color={
                              transaction.type === "Withdraw"
                                ? "red"
                                : transaction.type === "Deposit"
                                ? "green"
                                : "orange"
                            }
                            style={{
                              width: "130px",
                              textAlign: "center",
                              marginRight: 5,
                            }}
                          >
                            {transaction.type}
                          </Badge>
                        }
                      >
                        <Text size="sm" color="dimmed">
                          ${transaction.amount} on {transaction.dateTime}
                        </Text>
                      </List.Item>
                    ))}
                  </List>
                </ScrollArea>
              </Card.Section>
            </Card>
          </motion.div>
        </Col>
      </Grid>
    </Container>
  );
};

export default Dashboard;
