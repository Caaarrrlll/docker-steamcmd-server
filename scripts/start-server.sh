#!/bin/bash
if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
    echo "SteamCMD not found!"
    wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
    tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
    rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

echo "---Update SteamCMD---"
if [ "${USERNAME}" == "" ]; then
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +quit
else
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login ${USERNAME} ${PASSWRD} \
    +quit
fi

# TODO see how to automate updates for this / make it a param so people can pass in their own proton version if they want
if [ ! -f ${PROTON_DIR}/proton/proton ]; then
    echo "Proton not found!"
    wget -q -O ${PROTON_DIR}/proton.tar.gz https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton10-32/GE-Proton10-32.tar.gz
    tar --directory ${PROTON_DIR} -xvzf /serverdata/proton/proton.tar.gz
    rm ${PROTON_DIR}/proton.tar.gz
fi

echo "---Update Server---"
if [ "${USERNAME}" == "" ]; then
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir ${SERVER_DIR} \
        +login anonymous \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir ${SERVER_DIR} \
        +login anonymous \
        +app_update ${GAME_ID} \
        +quit
    fi
else
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir ${SERVER_DIR} \
        +login ${USERNAME} ${PASSWRD} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +force_install_dir ${SERVER_DIR} \
        +login ${USERNAME} ${PASSWRD} \
        +app_update ${GAME_ID} \
        +quit
    fi
fi

chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Server ready---"

echo "---Start Server---"
${PROTON_DIR}/proton run 
${SERVER_DIR}/ShooterGame/Binaries/Win64/ArkAscendedServer.exe ${MAP}?listen?SessionName=${SERVER_NAME}?ServerPassword=${SRV_PWD}?ServerAdminPassword=${SRV_ADMIN_PWD}${GAME_PARAMS} ${GAME_PARAMS_EXTRA}