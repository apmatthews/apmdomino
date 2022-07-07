# Get the the new plugin version
AFTER_PLUGIN_VERSION=$(wp plugin get my-cicd-plugin | sed -n "/version/p" | cut -f2)
echo "New test plugin version is: $AFTER_PLUGIN_VERSION"

# Revert to backup created by rsync
echo "Reverting to pre-deploy test plugin..."
rm -rf wp-content/plugins/my-cicd-plugin && mv /tmp/my-cicd-plugin wp-content/plugins/

# Get the old plugin version
BEFORE_PLUGIN_VERSION=$(wp plugin get my-cicd-plugin | sed -n "/version/p" | cut -f2)
echo "Old test plugin version was: $AFTER_PLUGIN_VERSION"

if [ "$BEFORE_PLUGIN_VERSION" = "$AFTER_PLUGIN_VERSION" ]; then
    echo "FAILURE: Test plugin was not updated" && exit 1
else
    echo "SUCCESS: Test plugin successfully updated from $BEFORE_PLUGIN_VERSION to $AFTER_PLUGIN_VERSION!"
fi

# Cleanup
rm wp-content/plugins/post-deploy.sh