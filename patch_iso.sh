#!/bin/bash
# This patcher is NOT OFFICIAL AND DOES NOT COME WITH ANY WARRANTY. 

echo
echo ====================================
echo Riibalanced ISO Patcher
echo ====================================
echo

# check for riibalanced files ---------------------------------------------------

if [[ ! -d "./V5/" ]]; then
  echo "ERROR: The Riibalanced patch files do not exist. Please download the zip file from the Riibalanced Discord, and extract the contents so that the folder 'V5' is in the same directory as 'patch_iso.sh'"
  echo
  echo "Like this:"
  echo "/your/current/directory"
  echo "├── patch_iso.sh
└── V5
    ├── Mario Kart Riibalanced V5.cover.png
    ├── Mario Kart Riibalanced V5.json
    ├── Mario Kart Riibalanced V5.png
    ├── readme.txt
    ├── Riibalanced
    ├── Riibalanced Extras
    └── riivolution
  "
  exit 3;
fi

# check if correct programs are installed ----------------------------------------

# curl ------
type curl
ERROR="$?"

if [[ ERROR -ne 0 ]]; then 
  echo
  echo "You must install 'curl' in order for this script to work correctly."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Try running 'xcode-select --install'."
  else
    echo "Please consult your system's package manager."
  exit 0
fi

# wit -------
type wit
ERROR="$?"
echo

if [[ ERROR -ne 0 ]]; then 
  echo "In order for the patcher to work, Wiimm's ISO Tools (https://wit.wiimm.de/) must be installed. By answering yes, you allow this script to download and install the software. Don't worry! This is completely safe. This program is developed by the same person who created Wiimmfi. The patcher cannot continue if wit is not installed."
  printf "Would you like to install wit? [y/n] "
  while read -r key; do
    case $key in
      n) echo "ERROR: Without wit, the patcher cannot continue."; exit 1 ;;
      y) break ;;
    esac
    printf "Would you like to install wit? [y/n] "
  done
  arch=$(uname -m)
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ $arch == x86_64* ]]; then
      curl https://wit.wiimm.de/download/wit-v3.04a-r8427-x86_64.tar.gz > wit.tar.gz
    elif [[ $arch == i*86 ]]; then
      curl https://wit.wiimm.de/download/wit-v3.04a-r8427-i386.tar.gz > wit.tar.gz
    else
      echo "ERROR: Your system's architecture ($arch) does not support Wiimm's ISO Tools. Please refer to wit's website for more information on how to install the tools. https://wit.wiimm.de/"
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    curl https://wit.wiimm.de/download/wit-v3.04a-r8427-mac.tar.gz > wit.tar.gz
  elif [[ "$OSTYPE" == "cygwin" ]]; then
    break
  else
    echo "Riibalanced Patcher: Your operating system ($OSTYPE) does not support Wiimm's ISO Tools. Please refer to wit's website for more information on how to install the tools. https://wit.wiimm.de/"
    exit 2;
  fi
  tar -xvf wit.tar.gz
  cd wit-v*/
  echo "You will now be prompted to enter your password for sudo in order for wit to install."
  sudo ./install.sh
  cd ..
  rm -rf wit-v*/
  # check if wit is installed now
  type wit
  ERROR="$?"
  echo

  if [[ ERROR -ne 0 ]]; then 
    echo "ERROR: wit still does not seem to be installed. Please make sure that '/usr/local/bin' is on your PATH by running 'echo \$PATH'."
    exit 4
  fi
fi

# check for image ------------------------------------------------

if [[ ! $1 ]]; then
  echo "ERROR: Please start this script with the path to the Mario Kart Wii ISO image to start the patch."
  echo "example: ./patch_iso.sh image/RMCE01.wbfs"
  exit 0
fi

# check for previous image extraction -----------------------------------

if [[ -d "./RMCE01/" ]]; then
  echo "The output directory for the image extraction exists (./RMCE01) and will be DELETED to get a fresh extraction."
  echo "Press [ENTER] to DELETE this directory and patch the image. Otherwise, press ^C now."
  read
  rm -rf ./RMCE01
fi

# start extract -----------------------------------------------------------

wit extract $1 RMCE01
ERROR="$?"

if [[ ERROR -ne 0 ]]; then 
  echo "ERROR: wit has returned non-zero exit code $ERROR. Please check that your image is in the specified location and the image is authentic and valid."
  exit $ERROR
fi

# start patch -------------------------------------------------------------

echo "Extraction seems to be complete. Starting patch."
#set -x

cp V5/Riibalanced/Core/StaticRU.rel RMCE01/DATA/files/rel/StaticR.rel
cp V5/Riibalanced/Core/MainU.dol RMCE01/DATA/sys/main.dol

cp V5/Riibalanced/Tracks/* RMCE01/DATA/files/Race/Course/
cp V5/Riibalanced/Textures/* RMCE01/DATA/files/Race/Kart/
cp V5/Riibalanced/Menus/* RMCE01/DATA/files/Scene/UI/

#cp V5/Riibalanced/Menus/Award.szs RMCE01/DATA/files/Scene/UI/
#cp V5/Riibalanced/Menus/Event.szs RMCE01/DATA/files/Scene/UI/
#cp V5/Riibalanced/Menus/Font.szs RMCE01/DATA/files/Scene/UI/
#cp V5/Riibalanced/Menus/Globe.szs RMCE01/DATA/files/Scene/UI/
#cp V5/Riibalanced/Menus/Present.szs RMCE01/DATA/files/Scene/UI/
#cp V5/Riibalanced/Menus/Race.szs RMCE01/DATA/files/Scene/UI/
#cp V5/Riibalanced/Menus/Title.szs RMCE01/DATA/files/Scene/UI/
#cp V5/Riibalanced/Menus/MenuMulti.szs RMCE01/DATA/files/Scene/UI/
#cp V5/Riibalanced/Menus/MenuOther.szs RMCE01/DATA/files/Scene/UI/
#cp V5/Riibalanced/Menus/MenuSingle.szs RMCE01/DATA/files/Scene/UI/
#music folder skipped to copy manually
cp V5/Riibalanced/Ghosts/ghost1_* RMCE01/DATA/files/Race/TimeAttack/ghost1/
cp V5/Riibalanced/Ghosts/ghost2_* RMCE01/DATA/files/Race/TimeAttack/ghost2/

cp V5/Riibalanced/Music/RKart/revo_kart.brsar RMCE01/DATA/files/sound/revo_kart.brsar
cp V5/Riibalanced/Core/Common.szs RMCE01/DATA/files/Race/Common.szs
#skipping trailer thp since its identical
#there are no remaining thps in the menus folder
#using menusingle inside the menu folder for now since it doesnt exist in the languages folder
#cp V5/Riibalanced/Menus/MenuSingle.szs RMCE01/DATA/files/Scene/UI/

cp V5/Riibalanced/Languages/Title_E.szs RMCE01/DATA/files/Scene/UI/Title_E.szs
cp V5/Riibalanced/Languages/Title_E.szs RMCE01/DATA/files/Scene/UI/Title_I.szs
cp V5/Riibalanced/Languages/Title_E.szs RMCE01/DATA/files/Scene/UI/Title_F.szs
cp V5/Riibalanced/Languages/Title_E.szs RMCE01/DATA/files/Scene/UI/Title_G.szs
cp V5/Riibalanced/Languages/Title_E.szs RMCE01/DATA/files/Scene/UI/Title_S.szs
cp V5/Riibalanced/Languages/Title_E.szs RMCE01/DATA/files/Scene/UI/Title_J.szs
cp V5/Riibalanced/Languages/Title_E.szs RMCE01/DATA/files/Scene/UI/Title_K.szs
cp V5/Riibalanced/Languages/Title_E.szs RMCE01/DATA/files/Scene/UI/Title_U.szs
cp V5/Riibalanced/Languages/Title_E.szs RMCE01/DATA/files/Scene/UI/Title_M.szs
cp V5/Riibalanced/Languages/Title_E.szs RMCE01/DATA/files/Scene/UI/Title_Q.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Race_E.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Race_I.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Race_F.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Race_G.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Race_S.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Race_U.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Race_M.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Race_J.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Race_K.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Race_Q.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Globe_E.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Globe_I.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Globe_F.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Globe_G.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Globe_S.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Globe_U.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Globe_M.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Globe_J.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Globe_K.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/Globe_Q.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuMulti_E.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuMulti_I.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuMulti_F.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuMulti_G.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuMulti_S.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuMulti_U.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuMulti_M.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuMulti_J.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuMulti_K.szs
cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuMulti_Q.szs
#cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuSingle_E.szs
#cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuSingle_I.szs
#cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuSingle_F.szs
#cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuSingle_G.szs
#cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuSingle_S.szs
#cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuSingle_U.szs
#cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuSingle_M.szs
#cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuSingle_J.szs
#cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuSingle_K.szs
#cp V5/Riibalanced/Languages/Race_E.szs RMCE01/DATA/files/Scene/UI/MenuSingle_Q.szs

#Copy all the music here
cp V5/Riibalanced/Music/n_block_F.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/n_block_n.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/n_circuit32_f.brstm RMCE01/DATA/files/sound/strm/n_Circuit32_f.brstm
cp V5/Riibalanced/Music/n_circuit32_n.brstm RMCE01/DATA/files/sound/strm/n_Circuit32_n.brstm
cp V5/Riibalanced/Music/n_daisy32_f.brstm RMCE01/DATA/files/sound/strm/n_Daisy32_f.brstm
cp V5/Riibalanced/Music/n_daisy32_n.brstm RMCE01/DATA/files/sound/strm/n_Daisy32_n.brstm
cp V5/Riibalanced/Music/n_farm_f.brstm RMCE01/DATA/files/sound/strm/n_Farm_F.brstm
cp V5/Riibalanced/Music/n_farm_n.brstm RMCE01/DATA/files/sound/strm/n_Farm_n.brstm
cp V5/Riibalanced/Music/n_kinoko_f.brstm RMCE01/DATA/files/sound/strm/n_Kinoko_F.brstm
cp V5/Riibalanced/Music/n_kinoko_n.brstm RMCE01/DATA/files/sound/strm/n_Kinoko_n.brstm
cp V5/Riibalanced/Music/n_maple_f.brstm RMCE01/DATA/files/sound/strm/n_maple_F.brstm
cp V5/Riibalanced/Music/n_maple_n.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/n_rainbow32_f.brstm RMCE01/DATA/files/sound/strm/n_Rainbow32_f.brstm
cp V5/Riibalanced/Music/n_rainbow32_n.brstm RMCE01/DATA/files/sound/strm/n_Rainbow32_n.brstm
cp V5/Riibalanced/Music/n_shopping32_f.brstm RMCE01/DATA/files/sound/strm/n_Shopping32_f.brstm
cp V5/Riibalanced/Music/n_shopping32_n.brstm RMCE01/DATA/files/sound/strm/n_Shopping32_n.brstm
cp V5/Riibalanced/Music/n_skate_F.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/n_skate_n.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/n_snowboard32_f.brstm RMCE01/DATA/files/sound/strm/n_Snowboard32_F.brstm
cp V5/Riibalanced/Music/n_snowboard32_n.brstm RMCE01/DATA/files/sound/strm/n_Snowboard32_n.brstm
cp V5/Riibalanced/Music/r_64_battle_F.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/r_64_battle_n.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/r_64_jungle32_f.brstm RMCE01/DATA/files/sound/strm/r_64_Jungle32_f.brstm
cp V5/Riibalanced/Music/r_64_kuppa32_f.brstm RMCE01/DATA/files/sound/strm/r_64_Kuppa32_f.brstm
cp V5/Riibalanced/Music/r_64_kuppa32_n.brstm RMCE01/DATA/files/sound/strm/r_64_Kuppa32_n.brstm
cp V5/Riibalanced/Music/r_64_sherbet32_f.brstm RMCE01/DATA/files/sound/strm/r_64_Sherbet32_f.brstm
cp V5/Riibalanced/Music/r_64_sherbet32_n.brstm RMCE01/DATA/files/sound/strm/r_64_Sherbet32_n.brstm
cp V5/Riibalanced/Music/r_agb_battle_F.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/r_agb_battle_n.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/r_agb_kuppa32_f.brstm RMCE01/DATA/files/sound/strm/r_AGB_Kuppa32_f.brstm
cp V5/Riibalanced/Music/r_agb_kuppa32_n.brstm RMCE01/DATA/files/sound/strm/r_AGB_Kuppa32_n.brstm
cp V5/Riibalanced/Music/r_DS_battle_F.brstm RMCE01/DATA/files/sound/strm/r_ds_battle_F.brstm
cp V5/Riibalanced/Music/r_DS_battle_n.brstm RMCE01/DATA/files/sound/strm/r_ds_battle_n.brstm
cp V5/Riibalanced/Music/r_ds_desert32_f.brstm RMCE01/DATA/files/sound/strm/r_DS_Desert32_f.brstm
cp V5/Riibalanced/Music/r_ds_desert32_n.brstm RMCE01/DATA/files/sound/strm/r_DS_Desert32_n.brstm
cp V5/Riibalanced/Music/r_ds_garden32_f.brstm RMCE01/DATA/files/sound/strm/r_DS_Garden32_f.brstm
cp V5/Riibalanced/Music/r_ds_garden32_n.brstm RMCE01/DATA/files/sound/strm/r_DS_Garden32_n.brstm
cp V5/Riibalanced/Music/r_ds_jungle32_f.brstm RMCE01/DATA/files/sound/strm/r_DS_Jungle32_f.brstm
cp V5/Riibalanced/Music/r_ds_jungle32_n.brstm RMCE01/DATA/files/sound/strm/r_DS_Jungle32_n.brstm
cp V5/Riibalanced/Music/r_ds_town32_f.brstm RMCE01/DATA/files/sound/strm/r_DS_Town32_f.brstm
cp V5/Riibalanced/Music/r_ds_town32_n.brstm RMCE01/DATA/files/sound/strm/r_DS_Town32_n.brstm
cp V5/Riibalanced/Music/r_GC_Battle32_F.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/r_GC_Battle32_n.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/r_gc_beach32_f.brstm RMCE01/DATA/files/sound/strm/r_GC_Beach32_f.brstm
cp V5/Riibalanced/Music/r_gc_beach32_n.brstm RMCE01/DATA/files/sound/strm/r_GC_Beach32_n.brstm
cp V5/Riibalanced/Music/r_gc_mountain32_f.brstm RMCE01/DATA/files/sound/strm/r_GC_Mountain32_f.brstm
cp V5/Riibalanced/Music/r_gc_mountain32_n.brstm RMCE01/DATA/files/sound/strm/r_GC_Mountain32_n.brstm
cp V5/Riibalanced/Music/r_gc_stadium32_f.brstm RMCE01/DATA/files/sound/strm/r_GC_Stadium32_f.brstm
cp V5/Riibalanced/Music/r_gc_stadium32_n.brstm RMCE01/DATA/files/sound/strm/r_GC_Stadium32_n.brstm
cp V5/Riibalanced/Music/r_sfc_battle_F.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/r_sfc_battle_n.brstm RMCE01/DATA/files/sound/strm/
cp V5/Riibalanced/Music/r_sfc_circuit32_f.brstm RMCE01/DATA/files/sound/strm/r_SFC_Circuit32_f.brstm
cp V5/Riibalanced/Music/r_sfc_circuit32_n.brstm RMCE01/DATA/files/sound/strm/r_SFC_Circuit32_n.brstm
cp V5/Riibalanced/Music/r_sfc_obake32_f.brstm RMCE01/DATA/files/sound/strm/r_SFC_Obake32_f.brstm
cp V5/Riibalanced/Music/r_sfc_obake32_n.brstm RMCE01/DATA/files/sound/strm/r_SFC_Obake32_n.brstm
cp V5/Riibalanced/Music/STRM_N_FACTORY_N.brstm RMCE01/DATA/files/sound/strm/

#set +x

echo
echo "Patch complete. wit will now compile the resulting disc image."

# overwrite check ------------------------------------------------------

if [[ -f "./riibalanced.wbfs" ]]; then
  echo "The file 'riibalanced.wbfs' exists in this directory."
  printf "Would you like to overwrite this file? Answering 'n' will move the file to 'riibalanced.wbfs.old' before continuing. [y/n] "
  while read -r key; do
    case $key in
      n) mv riibalanced.wbfs riibalanced.wbfs.old ; echo "Moved 'riibalanced.wbfs' to 'riibalanced.wbfs.old'"; break ;;
      y) rm riibalanced.wbfs ; break ;;
    esac
    printf "\n"
    printf "Would you like to overwrite this file? Answering 'n' will move the file to 'riibalanced.wbfs.old' before continuing. [y/n] "
  done
fi

# build ----------------------------------------------------------------

wit mix RMCE01/ -B --dest riibalanced.wbfs
wit edit riibalanced.wbfs --name MarioKartRiibalanced
rm -rf RMCE01/

echo "The patch is now complete. The resulting file is 'riibalanced.wbfs'. Enjoy!"

