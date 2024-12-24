# Setting Up a Virtual Machine (VM) on Google Cloud Platform (GCP)

This guide provides step-by-step instructions for configuring a virtual machine (VM) on Google Cloud Platform (GCP).

## Prerequisites

1. **Google Cloud Account**: Ensure you have an active Google Cloud account.
2. **Billing Enabled**: Verify that billing is enabled for your project in GCP.

## Step 1: Access the Google Cloud Console

1. Navigate to [Google Cloud Console](https://console.cloud.google.com/).
2. Log in with your Google account.

## Step 2: Create a New Project

1. In the top navigation bar, click the **Project Dropdown** and select **New Project**.
2. Provide a **Project Name**, and optionally, select an organization or folder.
3. Click **Create**.

## Step 3: Enable Compute Engine API

1. Go to the **APIs & Services** section in the left-hand menu.
2. Click **Enable APIs and Services**.
3. Search for "Compute Engine API" and enable it.

## Step 4: Configure the Virtual Machine

1. Navigate to **Compute Engine** > **VM instances**.
2. Click **Create Instance**.
3. Configure the following settings:
   - **Name**: Enter a unique name for your VM.
   - **Region and Zone**: Select the preferred region and zone for the VM.
   - **Availability policies**:
     - Standard: Higher cost → Not automatically stopped when GCP needs to perform maintenance (host maintenance).
     - Spot: Cheaper option → The VM might be paused or terminated.
   - **Machine Configuration**:
     - Choose the machine family (e.g., General-purpose).
     - Select the machine type (e.g., e2-medium).
   - **Boot Disk**:
     - Click **Change** to select an operating system (e.g., Ubuntu, Debian, or Windows).
     - Choose the disk size and type.
   - **Firewall Rules**:
     - Select "Allow HTTP traffic" and/or "Allow HTTPS traffic" if web connection is needed.
     - In this particular case, these options need to be enabled as the VM needs to send and receive requests via HTTP/HTTPS protocols to crawl data from Glamira website.

4. Click **Create**.

## Step 5: Connect to the Virtual Machine

1. Once the VM instance is created, locate it in the **VM instances** list.
2. Click **SSH** to open a terminal connection to the VM.

## Step 6: Configure the VM (Optional)

- Install necessary packages and software using the terminal.
- Set up any required environment variables or configurations.

## Step 7: Manage Your VM

- **Start/Stop the VM**: Use the buttons in the VM instances list to start or stop the VM.
- **Delete the VM**: To avoid unexpected charges, delete the VM when it is no longer needed.

## When to Use a Virtual Machine for Data ETL/ELT Tasks

Consider using a virtual machine instead of a personal computer for ETL (Extract, Transform, Load) or ELT (Extract, Load, Transform) tasks in the following scenarios:

- **Large Data Volumes**: When the data to be processed exceeds the storage or performance capacity of a personal computer.
- **High Computational Resources**: When ELT tasks require powerful CPU, RAM, or GPU resources beyond what your personal computer can provide.
- **High Availability**: When tasks need to run continuously without interruption due to factors like power outages or hardware failures.
- **Scalability**: When you need to easily scale resources (scale-up or scale-out) to process data faster or handle multiple tasks simultaneously.
- **Team Collaboration**: When multiple people are working on the same project and require a shared, easily accessible environment.
- **Integration with GCP Ecosystem**: When leveraging other GCP services such as BigQuery, Cloud Storage, or Dataflow to optimize the ELT process.

## Tips and Best Practices

- **Use Snapshots**: Regularly back up your VM using snapshots.
- **Monitor Billing**: Keep track of your GCP billing to avoid unexpected costs.
- **Apply Security Updates**: Regularly update the operating system and software on the VM.

For more detailed information, refer to the [GCP Documentation](https://cloud.google.com/docs).

