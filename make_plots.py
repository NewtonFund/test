import numpy as np
from matplotlib import pyplot as plt

# Load the timestamps in nanoseconds
# Running in docker
data = np.genfromtxt('output-docker.txt')
# Running natively
data_mac = np.genfromtxt('output-host.txt')

plt.figure(1)
plt.plot((data[:,2] - data[:,1])/1e9, label='Time to execute')
plt.plot((data[:,1] - data[:,0])/1e9, label='Time to wrap up')
plt.legend()
plt.title('Running in docker')
plt.xlabel('Run')
plt.ylabel('Time / s')
plt.savefig('docker-time.png')

plt.figure(2)
plt.plot((data_mac[:,2] - data_mac[:,1])/1e9, label='Time to execute')
plt.plot((data_mac[:,1] - data_mac[:,0])/1e9, label='Time to wrap up')
plt.legend()
plt.title('Running natively')
plt.xlabel('Run')
plt.ylabel('Time / s')
plt.savefig('native-time.png')

