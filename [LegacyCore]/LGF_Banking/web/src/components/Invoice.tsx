import React, { useState, useEffect } from "react";
import {
  Container,
  Grid,
  Col,
  Card,
  Title,
  Text,
  Button,
  TextInput,
  NumberInput,
  Select,
  Checkbox,
  Badge,
  ScrollArea,
  SegmentedControl,
  Divider,
  Menu,
  ActionIcon,
  Tooltip,
} from "@mantine/core";
import { motion } from "framer-motion";
import {
  IconPlus,
  IconListCheck,
  IconUser,
  IconBuilding,
  IconFileDollar,
  IconLibrary,
  IconDotsVertical,
  IconCheck,
  IconRefresh,
  IconTrash,
  IconFileInvoice,
} from "@tabler/icons-react";
import { fetchNui } from "../utils/fetchNui";
import { useNuiEvent } from "../hooks/useNuiEvent";

interface Invoice {
  id: string;
  title: string;
  amount: number;
  date: string;
  status: "paid" | "unpaid";
  invoiceType: "personal" | "society";
  description: string;
  societyName: string;
}

const Invoices: React.FC<{ visible: boolean; playerData: any }> = ({
  visible,
  playerData,
}) => {
  const [newInvoice, setNewInvoice] = useState<{
    playerId: string;
    amount: number | undefined;
    invoiceType: string;
    description: string;
    confirmed: boolean;
  }>({
    playerId: "",
    amount: undefined,
    invoiceType: "Personal",
    description: "",
    confirmed: false,
  });

  const [invoicesData, setInvoicesData] = useState<Invoice[]>([]);
  const [filterType, setFilterType] = useState("Personal");

  const handleMarkAsPaid = async (invoice: Invoice) => {
      await fetchNui("LGF_Banking.MarkInvoiceAsPaid", {
        id: invoice.id,
        payed: true,
        amount: invoice.amount,
        amountPlayerBank: playerData.AmountBank
      });
      fetchAllInvoice();
  };


  const handleDeleteInvoice = async (invoice: Invoice) => {
    await fetchNui("LGF_Banking.DeleteInvoicePayed", {
      id: invoice.id,
    });
    setTimeout(() => {
       fetchAllInvoice();
    }, 2000);
};


  useEffect(() => {
    if (visible) {
      fetchAllInvoice();
    }
  }, [visible]);

  const fetchAllInvoice = async () => {
    const invoices = (await fetchNui("LGF_Banking.GetAllInvoice")) as Invoice[];
    setInvoicesData(invoices);
  };

  useNuiEvent<any>("updateInvoice", () => {
    fetchAllInvoice()
  });

  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setNewInvoice((prev) => ({ ...prev, [name]: value }));
  };

  const handleCheckboxChange = (value: boolean) => {
    setNewInvoice((prev) => ({ ...prev, confirmed: value }));
  };

  const handleSelectChange = (value: string) => {
    setNewInvoice((prev) => ({ ...prev, invoiceType: value }));
  };

  const handleSubmit = async () => {
    await fetchNui("LGF_Banking.CreateNewInvoice", {
      PlayerID: newInvoice.playerId,
      Amount: newInvoice.amount,
      InvoiceType: newInvoice.invoiceType,
      Description: newInvoice.description,
      Confirmed: newInvoice.confirmed,
    });

    setNewInvoice({
      playerId: "",
      amount: 0,
      invoiceType: "",
      description: "",
      confirmed: false,
    });

    setTimeout(() => {
      fetchAllInvoice();
    }, 2000);
  };

  return (
    <Container p={0} w={900}>
      <Grid gutter="md">
        <Col span={8}>
          <Card
            padding="lg"
            withBorder
            h={590}
            shadow="md"
            style={{
              background: `transparent`,
              color: "#fff",
            }}
          >
            <Title
              order={4}
              style={{
                marginBottom: "5px",
                display: "flex",
                alignItems: "center",
              }}
            >
              <IconListCheck
                size={24}
                style={{ verticalAlign: "middle", marginRight: "10px" }}
              />
              Invoice List
              <div
                style={{
                  marginLeft: "auto",
                  display: "flex",
                  alignItems: "center",
                }}
              >
                <SegmentedControl
                  value={filterType}
                  onChange={setFilterType}
                  data={[
                    {
                      value: "Personal",
                      label: (
                        <div style={{ display: "flex", alignItems: "center" }}>
                          <IconUser size={16} style={{ marginRight: 5 }} />
                          Personal
                        </div>
                      ),
                    },
                    {
                      value: "Society",
                      label: (
                        <div style={{ display: "flex", alignItems: "center" }}>
                          <IconBuilding size={16} style={{ marginRight: 5 }} />
                          Society
                        </div>
                      ),
                    },
                  ]}
                  style={{ marginRight: "10px" }}
                  styles={{
                    root: {
                      background: `rgba(255, 255, 255, 0.1)`,
                      borderRadius: "4px", 
                    },
                    control: {
                      backgroundColor: "transparent", 
                      border: "none", 
                    },
                  }}
                />

                {/* <Tooltip label="Refresh Invoice" color="dark" withinPortal position="top-start">
                  <ActionIcon variant="transparent" onClick={fetchAllInvoice}>
                    <IconRefresh size={30} stroke={1} />
                  </ActionIcon>
                </Tooltip> */}
              </div>
            </Title>

            <Text size="sm" color="dimmed" style={{ marginBottom: "15px" }}>
              Manage all your invoices in one place.
            </Text>
            <ScrollArea scrollbarSize={0} h={475}>
              {invoicesData
                .filter((invoice) =>
                  filterType === "Personal"
                    ? invoice.invoiceType === "personal"
                    : invoice.invoiceType === "society"
                )
                .map((invoice, index) => (
                  <motion.div
                  key={invoice.id}
                  initial={{ opacity: 0, translateY: 20 }}
                  animate={{ opacity: 1, translateY: 0 }}
                  transition={{ duration: 0.5, delay: index * 0.1 }}
                >
                  <Card
                    padding="lg"
                    withBorder
                    shadow="sm"
                    style={{
                      background: `rgba(255, 255, 255, 0.1)`,
                      marginBottom: "10px",
                      display: "flex",
                      justifyContent: "space-between",
                      alignItems: "flex-start",
                      position: "relative",
                    }}
                  >
                    <div style={{ flex: 1 }}>
                      <Text
                        tt="uppercase"
                        size="lg"
                        weight={500}
                        style={{
                          display: "flex",
                          alignItems: "center",
                          marginBottom: "4px",
                        }}
                      >
                        {invoice.invoiceType === "personal" ? (
                          <IconUser size={18} style={{ marginRight: 8 }} />
                        ) : (
                          <IconBuilding size={18} style={{ marginRight: 8 }} />
                        )}
                        {invoice.title}
                      </Text>
                      <Text
                        size="sm"
                        color="dimmed"
                        style={{ marginBottom: "4px" }}
                      >
                        Amount: ${invoice.amount.toFixed(2)} | Due Date:{" "}
                        {invoice.date}
                      </Text>
                      <Text size="sm" color="dimmed">
                        Description: {invoice.description}
                      </Text>
                    </div>
          
                    <div style={{ display: "flex", alignItems: "center" }}>
                      <Badge
                        color={invoice.status === "paid" ? "green" : "red"}
                        variant="dot"
                        size="lg"
                        style={{ marginRight: 10 }}
                      >
                        {invoice.status === "paid" ? "Paid" : "Unpaid"}
                      </Badge>
          
                      {invoice.status === "unpaid" ? (
                        <Menu position="bottom-end" withinPortal withArrow>
                          <Menu.Target>
                            <ActionIcon
                              color="indigo"
                              variant="transparent"
                              style={{
                                position: "absolute",
                                bottom: "10px",
                                right: "10px",
                              }}
                            >
                              <IconDotsVertical size={20} />
                            </ActionIcon>
                          </Menu.Target>
                          <Menu.Dropdown>
                            <Menu.Item
                              icon={<IconCheck size={16} />}
                              onClick={() => handleMarkAsPaid(invoice)}
                            >
                              Mark as Paid
                            </Menu.Item>
                          </Menu.Dropdown>
                        </Menu>
                      ) : (
                        <Menu position="bottom-end" withinPortal withArrow>
                          <Menu.Target>
                            <ActionIcon
                              color="indigo"
                              variant="transparent"
                              style={{
                                position: "absolute",
                                bottom: "10px",
                                right: "10px",
                              }}
                            >
                              <IconDotsVertical size={20} />
                            </ActionIcon>
                          </Menu.Target>
                          <Menu.Dropdown>
                            <Menu.Item
                              icon={<IconTrash size={16} />}
                              color="red"
                              onClick={() => handleDeleteInvoice(invoice)}
                            >
                              Delete Invoice
                            </Menu.Item>
                          </Menu.Dropdown>
                        </Menu>
                      )}
                    </div>
                  </Card>
                </motion.div>
                ))}
            </ScrollArea>
          </Card>
        </Col>

        <Col span={4}>
          <Card
            padding="lg"
            withBorder
            shadow="md"
            h={590}
            style={{
              background: `transparent`,
              color: "#fff",
            }}
          >
            <Title order={4} style={{ marginBottom: "5px" }}>
              <IconPlus
                size={24}
                style={{ verticalAlign: "middle", marginRight: "10px" }}
              />
              Create New Invoice
            </Title>
            <Text size="sm" color="dimmed" style={{ marginBottom: "5px" }}>
              Create and manage new invoices easily.
            </Text>
            <form onSubmit={handleSubmit}>
              <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
                <TextInput
                  required
                  label="Enter Player ID"
                  name="playerId"
                  value={newInvoice.playerId}
                  onChange={handleInputChange}
                  placeholder="3"
                  description="The unique ID of the player."
                  style={{ marginBottom: "15px" }}
                  icon={<IconUser size={16} />}
                  styles={{
                    input: {
                      color: "#fff",
                      background: `rgba(255, 255, 255, 0.1)`,
                      border: "none",
                    },
                  }}
                />
              </motion.div>
              <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
                <NumberInput
                  required
                  label="Enter Amount"
                  name="amount"
                  value={newInvoice.amount}
                  onChange={(value) =>
                    setNewInvoice((prev) => ({
                      ...prev,
                      amount: value === "" ? undefined : value,
                    }))
                  }
                  placeholder="1500"
                  description="The amount for the invoice (e.g., in USD)."
                  style={{ marginBottom: "15px" }}
                  icon={<IconFileDollar size={16} />}
                  styles={{
                    input: {
                      color: "#fff",
                      background: `rgba(255, 255, 255, 0.1)`,
                      border: "none",
                    },
                  }}
                />
              </motion.div>

              <Select
                required
                label="Select Invoice Type"
                name="invoiceType"
                icon={<IconFileInvoice size={16} />}
                value={newInvoice.invoiceType}
                onChange={handleSelectChange}
                data={[
                  { value: "Personal", label: "Personal" },
                  { value: "Society", label: "Society" },
                ]}
                description="Choose the type of the invoice."
                styles={{
                  input: {
                    color: "#fff",
                    background: `rgba(255, 255, 255, 0.1)`,
                    border: "none",
                  },
                  dropdown: {
                    border: "none",
                  },
                  item: {
                    "&[data-selected]": {
                      backgroundColor: "rgba(100, 100, 100, 0.5)",
                      color: "#fff",
                    },
                    "&:hover": {
                      backgroundColor: "rgba(150, 150, 150, 0.5)",
                      color: "#fff",
                    },
                  },
                }}
                style={{ marginBottom: "15px" }}
              />

              <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
                <TextInput
                  required
                  label="Enter Description"
                  description="Enter Descrption of the Invoice"
                  name="description"
                  value={newInvoice.description}
                  onChange={handleInputChange}
                  placeholder="Briefly describe the invoice."
                  style={{ marginBottom: "15px" }}
                  icon={<IconLibrary size={16} />}
                  styles={{
                    input: {
                      color: "#fff",
                      background: `rgba(255, 255, 255, 0.1)`,
                      border: "none",
                    },
                  }}
                />
              </motion.div>
              <Divider
                my="xs"
                label="Label in the center"
                labelPosition="center"
              />
              <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}>
                <Checkbox
                  label="Confirm"
                  description="Confirm creation of the invoice"
                  checked={newInvoice.confirmed}
                  color="indigo"
                  required
                  onChange={(event) =>
                    handleCheckboxChange(event.currentTarget.checked)
                  }
                  style={{ marginBottom: "10px" }}
                />
              </motion.div>
              <Button
     
                leftIcon={<IconPlus size={16} />}
                variant="light"
                color="indigo"
                onClick={handleSubmit}
                fullWidth
              >
                Create Invoice
              </Button>
            </form>
          </Card>
        </Col>
      </Grid>
    </Container>
  );
};

export default Invoices;
