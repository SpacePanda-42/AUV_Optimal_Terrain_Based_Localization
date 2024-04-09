load beacon_mu_est_hist.mat
mu_beacon = mu_hist;
load beacon_true_path.mat
dp_path = trajectory;
load straight_mu_est_hist.mat
mu_straight = mu_hist;
load straight_true_path.mat
straight_path = trajectory;
load dp_mu_est_hist.mat
mu_dp = mu_hist;
load simple_case_varied.mat
mu_simple_varied = mu_hist;
load simple_case_traj.mat;
simple_traj = trajectory;
load simple_vase_flat.mat
mu_simple_flat = mu_hist;
load simple_case_repeated.mat
mu_simple_repeated = mu_hist;


% figure(1);
% hold on;
% plot(mu_beacon(1,:), mu_beacon(2,:), LineWidth=1.5)
% plot(mu_dp(1,:), mu_dp(2,:), LineWidth=1.5)
% plot(dp_path(:,1), dp_path(:,2), LineWidth=1.5)
% legend(["Estimated Position (PF with beacons)", "Estimated Position (PF with sonar)", "True Position"])
% % title("Particle Filter Results (Varied Terrain Full Trajectory, 500 Particles)")
% xlabel("X Position")
% ylabel("Y Position")
% xlim([-500, 500])
% ylim([-500, 500])
% hold off;
% 
% figure(2);
% hold on;
% plot(sqrt((mu_beacon(1,:) - dp_path(:,1).').^2 + (mu_beacon(2,:) - dp_path(:,2).').^2), LineWidth=1.5)
% plot(sqrt((mu_dp(1,:) - dp_path(:,1).').^2 + (mu_dp(2,:) - dp_path(:,2).').^2), LineWidth = 1.5)
% % title("Position Estimate Error (Euclidean Distance, 500 Particles)")
% legend(["Estimated Position Error (PF with beacons)", "Estimated Position Error (PF with sonar)"])
% ylim([0, 90])
% xlabel("Time")
% ylabel("Error")
% hold off;
% 
% figure(3);
% hold on;
% plot(sqrt((mu_straight(1,:) - straight_path(:,1).').^2 + (mu_straight(2,:) - straight_path(:,2).').^2), LineWidth = 1.5)
% legend("Estimated Position Error (PF with straight trajectory)")
% ylim([0,90])
% xlabel("Time")
% ylabel("Error")
% hold off;
% 
% figure(4);
% hold on;
% plot(mu_straight(1,:), mu_straight(2,:), LineWidth=1.5)
% plot(straight_path(:,1), straight_path(:,2), LineWidth=1.5)
% legend(["Estimated Position (PF with sonar)", "True Position"])
% % title("Particle Filter Results (Varied Terrain Full Trajectory, 500 Particles)")
% xlabel("X Position")
% ylabel("Y Position")
% xlim([-500, 500])
% ylim([-500, 500])
% hold off;

figure(5);
hold on;
plot(mu_simple_varied(1,:), mu_simple_varied(2,:), LineWidth=1.5)
plot(mu_simple_flat(1,:), mu_simple_flat(2,:), LineWidth=1.5)
plot(mu_simple_repeated(1,:), mu_simple_repeated(2,:), LineWidth=1.5)
plot(simple_traj(:,1), simple_traj(:,2), LineWidth=1.5)
legend(["Varied terrain state estimation", "Flat terrain state estimation", "Repeated terrain state estimation", "True state"])
xlabel("X Position")
ylabel("Y Position")
xlim([-80, 350])
ylim([-350, 100])
hold off;

figure(6);
hold on;
plot(sqrt((mu_simple_varied(1,:) - simple_traj(:,1).').^2 + (mu_simple_varied(2,:) - simple_traj(:,2).').^2), LineWidth=1.5)
plot(sqrt((mu_simple_flat(1,:) - simple_traj(:,1).').^2 + (mu_simple_flat(2,:) - simple_traj(:,2).').^2), LineWidth=1.5)
plot(sqrt((mu_simple_repeated(1,:) - simple_traj(:,1).').^2 + (mu_simple_repeated(2,:) - simple_traj(:,2).').^2), LineWidth=1.5)

legend(["Varied terrain state estimation", "Flat terrain state estimation", "Repeated terrain state estimation"])
xlabel("X Position")
ylabel("Y Position")
% xlim([-80, 350])
% ylim([-350, 100])
hold off;



straight_error = mean(sqrt((mu_straight(1,:) - straight_path(:,1).').^2 + (mu_straight(2,:) - straight_path(:,2).').^2));
dp_error = mean(sqrt((mu_dp(1,:) - dp_path(:,1).').^2 + (mu_dp(2,:) - dp_path(:,2).').^2));
disp(straight_error)
disp(dp_error)





