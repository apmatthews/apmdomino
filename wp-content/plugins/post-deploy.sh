# Get the the new plugin version and set as action output
AFTER_PLUGIN_VERSION=$(wp plugin get my-cicd-plugin | sed -n "/version/p" | cut -f2)
echo "::set-output name=after_version::$AFTER_PLUGIN_VERSION"

# Revert to backup created by rsync
rm -rf wp-content/plugins/my-cicd-plugin && mv /tmp/my-cicd-plugin wp-content/plugins/

# Get the old plugin version and set as action output
BEFORE_PLUGIN_VERSION=$(wp plugin get my-cicd-plugin | sed -n "/version/p" | cut -f2)
echo "::set-output name=before_version::$BEFORE_PLUGIN_VERSION"

if [ BEFORE_PLUGIN_VERSION == AFTER_PLUGIN_VERSION ]; then
    echo "Test plugin was not updated" && exit 1
else
    echo "Test plugin successfully updated from $BEFORE_PLUGIN_VERSION to $AFTER_PLUGIN_VERSION!"
fi

# Cleanup
rm wp-content/plugins/post-deploy.sh