[[ "$0" != "$BASH_SOURCE" ]] && export install_dir=$(dirname "$BASH_SOURCE") || export install_dir=$(dirname $0)
source kiali.conf

function install(){
  echo  "========================================================================="
  echo  "=======================  Start Installing kiali ========================"
  echo  "========================================================================="

  cp "$install_dir/yaml/kiali.yaml" "$install_dir/yaml/kiali_modified.yaml"

  if [[ "$imageRegistry" != "" ]]; then
    sed -i 's/quay.io\/kiali\/kiali/'${REGISTRY}'\/kiali\/kiali/g' "$install_dir/yaml/kiali_modified.yaml"
  fi

  sed -i 's/{KIALI_VERSION}/'$kialiVersion'/g' "$install_dir/yaml/kiali_modified.yaml"
  sed -i 's/{HYPERAUTH_IP}/'$hyperAuthIP'/g' "$install_dir/yaml/kiali_modified.yaml"
  sed -i "s/{CLIENT_ID}/$clientId/g" "$install_dir/yaml/kiali_modified.yaml"
  sed -i 's/{CUSTOM_DOMAIN_NAME}/'$customDomainName'/g' "$install_dir/yaml/kiali_modified.yaml"


  kubectl apply -f "$install_dir/yaml/kiali_modified.yaml"

  echo  "========================================================================="
  echo  "====================  Successfully Installed kiali ====================="
  echo  "========================================================================="
}

function uninstall(){
  echo  "========================================================================="
  echo  "======================  Start Uninstalling kiali ======================="
  echo  "========================================================================="

  kubectl delete -f "$install_dir/yaml/kiali_modified.yaml"

  echo  "========================================================================="
  echo  "===================  Successfully Uninstalled kiali ===================="
  echo  "========================================================================="
}


function main(){
  case "${1:-}" in
    install)
      install
      ;;
    uninstall)
      uninstall
      ;;
    *)
      echo "Usage: $0 [install|uninstall]"
      ;;
  esac
}

main "$1"
