#! /bin/bash

echo "MultiVersion | Take Off 1.1";
echo "Made By Dviih. https://discord.gg/Fqmhcs45pp";

if [[ "$MV_FILE" == *".jar" ]]; then

    if [[ -z "$MC_VERSION" || -z "$MC_VARIANT" ]]; then
        echo "Hello, You need to set the variables for Minecraft!";
        echo "Go to startup tab and change";
        exit 11;
    fi

    MC_VERSION_CUT=$(echo "$MC_VERSION" | cut -d "." -f 2)

    case "$MC_VERSION_CUT" in
        1[8-9]|2[0-9]|"latest")
            MV_JAVA_VERSION=17
            ;;
        17)
            MV_JAVA_VERSION=16
            ;;
        *)
            MV_JAVA_VERSION=8
            ;;
    esac

    if [[ ! -f "$MV_FILE" ]]; then
        curl -sL https://mirror.dviih.tech/minecraft/"$MC_VARIANT"/"$MC_VERSION" -o "$MV_FILE";
    fi

    /usr/lib/jvm/java-"$MV_JAVA_VERSION"-openjdk-amd64/bin/java -version
    /usr/lib/jvm/java-"$MV_JAVA_VERSION"-openjdk-amd64/bin/java -Xmx"$SERVER_MEMORY"M -jar "$MV_FILE";
    exit 1;

fi

if [[ "$MV_FILE" == *".phar" ]]; then

    if [[ -z "$MC_VERSION" ]]; then
        echo "Hello, You need to set the variables for Minecraft!";
        echo "Go to startup tab and change";
        exit 11;
    fi

    if [[ ! -f "$MV_FILE" ]]; then
        curl -sL https://mirror.dviih.tech/minecraft/pocketmine/"$MC_VERSION" -o "$MV_FILE";
    fi

    /opt/bin/php7/bin/php --version
    /opt/bin/php7/bin/php "$MV_FILE";
    exit 0;

fi

if [[ "$MV_FILE" == *".js" ]]; then

    if [[ -f package.json && ! -d node_modules ]]; then
        npm install
    fi

    if [[ -f "$MV_FILE" ]]; then
        echo "NodeJS: $(node -v) [NPM: $(npm -v)]";
        node "$MV_FILE";
    else
        exit 2;
    fi

    exit 0;

fi

if [[ "$MV_FILE" == *".py" ]]; then

    if [[ -f requeriments.txt && ! -d "$HOME/.local/lib/python*/site-packages" ]]; then
        pip install -r requeriments.txt
    fi

    if [[ -f "$MV_FILE" ]]; then
        echo "$(python3 --version) [$(pip --version | awk '{print $1" "$2}')]";
        python3 "$MV_FILE";
    else
        exit 2;
    fi

    exit 0;

fi

if [[ "$MC_VARIANT" == "bedrock_server" ]]; then

    if [[ -z "$MC_VERSION" || -z "$MV_FILE" ]]; then
        echo "Hello, You need to set the variables for Minecraft!";
        echo "Go to startup tab and change";
        exit 11;
    fi

    if [[ ! -f "$MV_FILE" ]]; then
        curl -sL https://mirror.dviih.tech/minecraft/bedrock/"$MC_VERSION" -o "bedrock_server.zip";
        unzip bedrock_server.zip
        rm bedrock_server.zip
        mv bedrock_server "$MV_FILE"
    fi

    LD_LIBRARY_PATH=. ./"$MV_FILE";
    exit 0;

fi

exit 1;