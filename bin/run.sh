SCRIPT_DIR=$(dirname $0)
APP_HOME=$(cd $SCRIPT_DIR/.. && pwd)
CATALINA_BASE=$APP_HOME catalina.sh run
