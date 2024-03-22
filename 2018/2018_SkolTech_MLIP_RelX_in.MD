##################################################
# - units: 
units metal
atom_style atomic
##################################################
# mpi domain split optimization: 
comm_style brick
processors * * 1
##################################################
# - Relaxation convergence: 
variable etol equal 0
variable ftol equal 0.001
variable eiter equal 1000
variable fiter equal 1000
##################################################
# - settings  
variable ii equal 1
variable seed equal 4928459
variable temperature equal 600
variable FreQ equal 1
variable abc equal 3.5667 
variable apart equal 0.1
variable zjump equal 5 # A fs 
#variable speed equal 50 # A ps ::: 	1A ps=100 m s
#variable everyI equal $(1000*v_zjump/v_speed) 
# - lattice 
lattice diamond $(v_abc)
# - workmaterial 
variable Lx equal 10
variable Ly equal 10
variable Lz equal 5
region workmaterial block 0 $(v_Lx) 0 $(v_Ly) 0 $(v_Lz) side in units lattice
boundary p p f
# - tip 
variable tipf equal 50000
variable tiprad equal 5
variable tipx equal $(0.5*v_Lx*v_abc)
variable tipy equal $(0.5*v_Ly*v_abc)
variable tipz equal "v_Lz*v_abc + v_tiprad + v_apart - step*dt*v_zjump" 
##################################################
# - simulation box
region System block 0 $(v_Lx) 0 $(v_Ly) 0 $(v_Lz+v_tiprad+2*v_apart) side in units lattice
boundary p p f
create_box 1 System
##################################################
# - creating atoms
create_atoms 1 region workmaterial 
mass 1 12.01 
group workmaterialG region workmaterial
##################################################
# - potential settings
pair_style mlip mlip.ini
pair_coeff * *
neighbor 1.5 bin
#pair_style lj/cut 2.5
#pair_coeff * * 1.0 1.0 2.5
##################################################
# - MD+RelX
timestep 0.001
variable totT equal $((v_Lz*v_abc + v_tiprad + v_apart)/(v_zjump*0.001))
variable currT equal "step"
# - Dyna
velocity all create $(v_temperature) $(v_seed)
fix bottom workmaterialG wall/reflect zlo EDGE zhi EDGE
fix nvtENS all nvt temp $(v_temperature) $(v_temperature) 0.001
fix tip all indent $(v_tipf) sphere v_tipx v_tipy v_tipz v_tiprad      # in angstroms
# - outputs
thermo_style custom step atoms temp pe ke press v_tipz fmax
thermo $(v_FreQ)
dump dumping all custom $(v_FreQ) dumps/trj.* id x y z fx fy fz vx vy vz
# - RUN 
run $(ceil(v_totT))
#if "$(v_currT) > $(v_ii*v_everyI)" then &
#"print 'running minimization in time step $(v_currT)'" &
#"minimize $(v_etol) $(v_ftol) $(v_eiter) $(v_fiter)" &
#"reset_timestep $(v_currT)" &
#"variable ii equal $(v_ii+1)"
##################################################