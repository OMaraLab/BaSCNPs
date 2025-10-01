
i=3 # composition
j=1 # conformation


while [ $i -le 5 ] ; do

    mkdir poly0${i}
    python polyconf.py --name "poly0${i}/polymer_0${i}" --nconfs 3 --count --length 200 --shuffles 50 --monomers monomers.csv 2>&1 | tee poly0${i}/polyconf.log  

    mkdir poly0${i}/conf_test
    cp -r BaSCNP_gromos54a7_atb.ff poly0${i}/conf_test/BaSCNP_gromos54a7_atb.ff
    printf "1\n2\n" | gmx pdb2gmx -f poly0${i}/polymer_0${i}_${j}.gro -o poly0${i}/conf_test/01_polymer_0${i}_test.gro -p poly0${i}/conf_test/polymer_0${i}_master.top -i poly0${i}/conf_test/polymer_0${i}_posre.itp 2>&1 | tee poly0${i}/conf_test/01_pdb2gmx.txt  # SPC/E
    
    cd poly0${i}/conf_test

    gmx grompp -f ../../minimise.mdp -p polymer_0${i}_master.top -c 01_polymer_0${i}_test.gro -o 01_polymer_0${i}_r${j}_EM_test.tpr -maxwarn 1 2>&1 | tee 03_grompp_test.txt
    cp polymer_0${i}_master.top ../
    cd ../..


    j=1
    i=$(( $i + 1 ))

    done
