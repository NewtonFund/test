import numpy as np
from matplotlib import pyplot as plt

# Load the timestamps in nanoseconds
# Running in docker
data_docker = np.genfromtxt('io-time-output-docker.txt')
# Running natively
data_host = np.genfromtxt('io-time-output-host.txt')

plt.figure(1)
plt.clf()
plt.plot((data_docker[:,-1] - data_docker[:,1])/1e9, label='Time to execute')
plt.plot((data_docker[:,1] - data_docker[:,0])/1e9, label='Time to wrap up')
plt.legend()
plt.grid()
plt.xlim(0,len(data_docker[:,1]))
plt.title('Running in docker')
plt.xlabel('Run')
plt.ylabel('Time / s')
plt.savefig('io-docker-time.png')

plt.figure(2)
plt.clf()
plt.plot((data_host[:,-1] - data_host[:,1])/1e9, label='Time to execute')
plt.plot((data_host[:,1] - data_host[:,0])/1e9, label='Time to wrap up')
plt.legend()
plt.grid()
plt.xlim(0,len(data_host[:,1]))
plt.title('Running natively')
plt.xlabel('Run')
plt.ylabel('Time / s')
plt.savefig('io-native-time.png')

plt.figure(3)
plt.clf()
plt.plot((data_docker[:,-2]-data_docker[:,1])/1e9, label="Time to run 1000 times in Docker")
plt.plot([0,len(data_docker[:,1])],[np.mean((data_docker[:,-2]-data_docker[:,1])/1e9), np.mean((data_docker[:,-2]-data_docker[:,1])/1e9)], ls=":", color='C0')
plt.plot((data_host[:,-2]-data_host[:,1])/1e9, label="Time to run 1000 times in host")
plt.plot([0,len(data_host[:,1])],[np.mean((data_host[:,-2]-data_host[:,1])/1e9), np.mean((data_host[:,-2]-data_host[:,1])/1e9)], ls=":", color='C1')
plt.legend()
plt.grid()
plt.xlim(0,len(data_host[:,1]))
plt.ylim(ymin=0)
plt.title('Run time compared')
plt.xlabel('Run')
plt.ylabel('Time / s')
plt.savefig('io-run-time.png')


# Load the timestamps in nanoseconds
# Running in docker
data_docker = np.genfromtxt('cal-time-output-docker.txt')
# Running natively
data_host = np.genfromtxt('cal-time-output-host.txt')


plt.figure(1)
plt.clf()
plt.plot((data_docker[:,-1] - data_docker[:,1])/1e9, label='Time to execute')
plt.plot((data_docker[:,1] - data_docker[:,0])/1e9, label='Time to wrap up')
plt.legend()
plt.grid()
plt.xlim(0,len(data_docker[:,1]))
plt.title('Running in docker')
plt.xlabel('Run')
plt.ylabel('Time / s')
plt.savefig('cal-docker-time.png')

plt.figure(2)
plt.clf()
plt.plot((data_host[:,-1] - data_host[:,1])/1e9, label='Time to execute')
plt.plot((data_host[:,1] - data_host[:,0])/1e9, label='Time to wrap up')
plt.legend()
plt.grid()
plt.xlim(0,len(data_host[:,1]))
plt.title('Running natively')
plt.xlabel('Run')
plt.ylabel('Time / s')
plt.savefig('cal-native-time.png')

plt.figure(3)
plt.clf()
plt.plot((data_docker[:,1])/1e9, label="Time to run 100,000,000 times in Docker", color='C0')
plt.plot([0,len(data_docker[:,1])],[np.mean((data_docker[:,1])/1e9), np.mean((data_docker[:,1])/1e9)], ls=":", color='C0')
plt.plot((data_host[:,1])/1e9, label="Time to run 100,000,000 times in host", color='C1')
plt.plot([0,len(data_host[:,1])],[np.mean((data_host[:,1])/1e9), np.mean((data_host[:,1])/1e9)], ls=":", color='C1')
plt.legend()
plt.grid()
plt.xlim(0,len(data_host[:,1]))
plt.ylim(ymin=0)
plt.title('Run time compared')
plt.xlabel('Run')
plt.ylabel('Time / s')
plt.savefig('cal-run-time.png')


