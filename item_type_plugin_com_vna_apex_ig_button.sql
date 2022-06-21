prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_210200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2021.10.15'
,p_release=>'21.2.0'
,p_default_workspace_id=>1824713498526400
,p_default_application_id=>126
,p_default_id_offset=>0
,p_default_owner=>'ODS'
);
end;
/
 
prompt APPLICATION 126 - Accounts Payable
--
-- Application Export:
--   Application:     126
--   Name:            Accounts Payable
--   Date and Time:   01:06 Tuesday June 21, 2022
--   Exported By:     EESPINOZA
--   Flashback:       0
--   Export Type:     Component Export
--   Manifest
--     PLUGIN: 304476015496908876
--   Manifest End
--   Version:         21.2.0
--   Instance ID:     248215327277049
--

begin
  -- replace components
  wwv_flow_api.g_mode := 'REPLACE';
end;
/
prompt --application/shared_components/plugins/item_type/com_vna_apex_ig_button
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(304476015496908876)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'COM_VNA_APEX_IG_BUTTON'
,p_display_name=>'VNA  - Interactive Grid Button'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_javascript_file_urls=>'#PLUGIN_FILES#vna_ig_button#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PROCEDURE render(p_item   IN apex_plugin.t_item,',
'									 p_plugin IN apex_plugin.t_plugin,',
'									 p_param  IN apex_plugin.t_item_render_param,',
'									 p_result IN OUT NOCOPY apex_plugin.t_item_render_result) IS',
'    l_toolbar_position	VARCHAR2(4000) := p_item.attribute_06;',
'	l_action 			VARCHAR2(4000) := p_item.attribute_01;',
'    l_label				VARCHAR2(4000) := p_item.attribute_08;',
'    l_icon 				VARCHAR2(4000) := p_item.attribute_02;',
'	l_icon_only   		VARCHAR2(4000) := p_item.attribute_07;',
'    l_icon_position   	VARCHAR2(4000) := p_item.attribute_03;',
'    l_hot				VARCHAR2(4000) := p_item.attribute_05;',
'    l_button_actions_js	VARCHAR2(4000) := p_item.attribute_09;',
'',
'    l_ig_static_id 		VARCHAR2(4000);',
'    l_button_init_js	VARCHAR2(8000);',
'    l_button_json_config 	VARCHAR2(4000);',
'  BEGIN',
'    BEGIN',
'   		SELECT COALESCE(static_id, ''R''||region_id) AS ig_static_id',
'     		INTO l_ig_static_id',
'        FROM apex_application_page_regions',
'       WHERE region_id = p_item.region_id',
'         AND source_type_code = ''NATIVE_IG'';',
'    EXCEPTION',
'    	WHEN NO_DATA_FOUND THEN',
'        raise_application_error(-20001, ''VNA Interactive Grid Button can only be attached to an Interactive Grid'');',
'    END;',
'',
'		apex_json.initialize_clob_output;',
'    apex_json.open_object;',
'    IF l_toolbar_position IS NOT NULL THEN',
'      apex_json.write(''toolbarPosition'', l_toolbar_position);',
'    END IF;',
'',
'    apex_json.open_object(''config'');',
'',
'    apex_json.write(''type'', ''BUTTON'');',
'',
'    IF l_action IS NOT NULL THEN',
'    	apex_json.write(''action'', l_action);',
'    END IF;',
'',
'    IF l_label IS NOT NULL THEN',
'    	apex_json.write(''label'', l_label);',
'    ELSE',
'    	apex_json.write(''label'', '''');',
'    END IF;',
'',
'    IF l_icon IS NOT NULL THEN',
'      -- If icon is a Font APEX icon then add prefix ''fa'' for correct CSS',
'      IF REGEXP_COUNT(l_icon, ''^fa\-.*'') > 0 THEN',
'	      l_icon := ''fa '' || l_icon;',
'      END IF;',
'',
'      apex_json.write(''icon'', l_icon);',
'    END IF;',
'',
'    IF l_icon_only IS NOT NULL THEN',
'      apex_json.write(''iconOnly'', l_icon_only = ''Y'');',
'    END IF;',
'',
'    IF l_icon_only IS NOT NULL AND l_icon_only = ''N'' THEN',
'      IF l_icon_position IS NOT NULL THEN',
'        apex_json.write(''iconBeforeLabel'', l_icon_position = ''BEFORE_LABEL'');',
'      END IF;',
'    END IF;',
'',
'    IF l_hot IS NOT NULL THEN',
'      apex_json.write(''hot'', l_hot = ''Y'');',
'    END IF;',
'',
'    apex_json.close_all;',
'',
'    l_button_json_config := TO_CHAR(apex_json.get_clob_output);',
'',
'    IF l_action IS NOT NULL AND l_button_actions_js IS NOT NULL THEN',
'      l_button_init_js := q''~VnaIgButton.addButton(''#IG_STATIC_ID#'',#BUTTON_JSON_COFIG#);',
'VnaIgButton.addButtonActionsFn(''#IG_STATIC_ID#'',''#BUTTON_ACTION_NAME#'', #BUTTON_ACTION_FN#, ''#BUTTON_ACTION_LABEL#'');',
'~'';',
'		ELSE',
'      l_button_init_js := q''~VnaIgButton.addButton(''#IG_STATIC_ID#'',#BUTTON_JSON_COFIG#);~'';',
'    END IF;',
'',
'    l_button_init_js := REPLACE(l_button_init_js, ''#BUTTON_JSON_COFIG#'', l_button_json_config);',
' 		l_button_init_js := REPLACE(l_button_init_js, ''#IG_STATIC_ID#'', l_ig_static_id);',
'    l_button_init_js := REPLACE(l_button_init_js, ''#BUTTON_ACTION_NAME#'', l_action);',
'    l_button_init_js := REPLACE(l_button_init_js, ''#BUTTON_ACTION_FN#'', l_button_actions_js);',
'    l_button_init_js := REPLACE(l_button_init_js, ''#BUTTON_ACTION_LABEL#'', l_label);',
'    ',
'    apex_javascript.add_onload_code(p_code 	=> l_button_init_js,',
'    																p_key 	=> ''VNA_IG_BUTTON_JS_INIT_'' || p_item.id);',
'    apex_json.free_output;',
'END render;'))
,p_api_version=>2
,p_render_function=>'render'
,p_standard_attributes=>'INIT_JAVASCRIPT_CODE'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Add the below JavaScript Initialization code in the Interactive Grid''s attributes</p>',
'',
'<pre>',
'function(options) {',
'    let igStaticId = options && options.regionStaticId,',
'        toolbarData = $.apex.interactiveGrid.copyDefaultToolbar();',
'',
'    VnaIgButton.initToolbarData(igStaticId, toolbarData);   ',
'    options.initActions = function (actions) {',
'        VnaIgButton.initActions(igStaticId, actions);',
'    }',
'',
'    options.toolbarData = toolbarData;',
'',
'    return options;',
'}',
'</pre>'))
,p_version_identifier=>'0.1.0'
,p_files_version=>15
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304477367844006782)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>20
,p_prompt=>'Action'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304478005779009895)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>50
,p_prompt=>'Icon Image/Class'
,p_attribute_type=>'ICON'
,p_is_required=>false
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304480630388029376)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304478578683013683)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>60
,p_prompt=>'Icon Position'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'AFTER_LABEL'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304480630388029376)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304479117290019351)
,p_plugin_attribute_id=>wwv_flow_api.id(304478578683013683)
,p_display_sequence=>10
,p_display_value=>'Before Label'
,p_return_value=>'BEFORE_LABEL'
,p_is_quick_pick=>true
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304479551704021674)
,p_plugin_attribute_id=>wwv_flow_api.id(304478578683013683)
,p_display_sequence=>20
,p_display_value=>'After Label'
,p_return_value=>'AFTER_LABEL'
,p_is_quick_pick=>true
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304480630388029376)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Icon'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304482787000037927)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>80
,p_prompt=>'Hot'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304549594130190126)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>10
,p_prompt=>'Toolbar Position'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>true
,p_default_value=>'actions4'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304550233790192492)
,p_plugin_attribute_id=>wwv_flow_api.id(304549594130190126)
,p_display_sequence=>10
,p_display_value=>'All search controls (column search menu, search field and go button)'
,p_return_value=>'search'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304550649025193960)
,p_plugin_attribute_id=>wwv_flow_api.id(304549594130190126)
,p_display_sequence=>20
,p_display_value=>'Saved report select list'
,p_return_value=>'reports'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304551000876195061)
,p_plugin_attribute_id=>wwv_flow_api.id(304549594130190126)
,p_display_sequence=>30
,p_display_value=>'View selection pill buttons'
,p_return_value=>'views'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304551355622196010)
,p_plugin_attribute_id=>wwv_flow_api.id(304549594130190126)
,p_display_sequence=>40
,p_display_value=>'Actions menu button'
,p_return_value=>'actions1'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304551827079197051)
,p_plugin_attribute_id=>wwv_flow_api.id(304549594130190126)
,p_display_sequence=>50
,p_display_value=>'Edit and Save buttons'
,p_return_value=>'actions2'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304552213236198282)
,p_plugin_attribute_id=>wwv_flow_api.id(304549594130190126)
,p_display_sequence=>60
,p_display_value=>'Add Row button'
,p_return_value=>'actions3'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(304552590448199733)
,p_plugin_attribute_id=>wwv_flow_api.id(304549594130190126)
,p_display_sequence=>70
,p_display_value=>'Reset report button'
,p_return_value=>'actions4'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304559007692275010)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Icon Only'
,p_attribute_type=>'CHECKBOX'
,p_is_required=>false
,p_default_value=>'N'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304480630388029376)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'Y'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304562136400286364)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>30
,p_prompt=>'Label'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304559007692275010)
,p_depending_on_has_to_exist=>false
,p_depending_on_condition_type=>'NOT_EQUALS'
,p_depending_on_expression=>'Y'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(304766346085493387)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>25
,p_prompt=>'Action - JavaScript'
,p_attribute_type=>'JAVASCRIPT'
,p_is_required=>true
,p_default_value=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function( event, focusElement ) {',
'}'))
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(304477367844006782)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_NULL'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'function( event, focusElement ) {',
'  apex.message.alert( "Hello World!" );',
'}',
'</pre>'))
);
wwv_flow_api.create_plugin_std_attribute(
 p_id=>wwv_flow_api.id(304585110840361530)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_name=>'INIT_JAVASCRIPT_CODE'
,p_is_required=>false
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '636C61737320566E614967427574746F6E7B0D0A202073746174696320616464427574746F6E28696753746174696349642C20627574746F6E436F6E666967297B0D0A202020206966282177696E646F772E766E614967427574746F6E73290D0A202020';
wwv_flow_api.g_varchar2_table(2) := '20202077696E646F772E766E614967427574746F6E73203D205B5D3B0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200D0A202020206966282177696E646F77';
wwv_flow_api.g_varchar2_table(3) := '2E766E614967427574746F6E735B696753746174696349645D290D0A20202020202077696E646F772E766E614967427574746F6E735B696753746174696349645D3D205B5D3B0D0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(4) := '202020202020202020202020202020202020202020202020200D0A2020202077696E646F772E766E614967427574746F6E735B696753746174696349645D2E7075736828627574746F6E436F6E666967293B0D0A20207D0D0A20200D0A20207374617469';
wwv_flow_api.g_varchar2_table(5) := '6320616464427574746F6E416374696F6E73466E28696753746174696349642C20616374696F6E4E616D652C20616374696F6E466E2C20616374696F6E4C6162656C297B0D0A202020206966282177696E646F772E766E614967416374696F6E466E7329';
wwv_flow_api.g_varchar2_table(6) := '0D0A20202020202077696E646F772E766E614967416374696F6E466E73203D205B5D3B0D0A2020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200D0A20202020696628';
wwv_flow_api.g_varchar2_table(7) := '2177696E646F772E766E614967416374696F6E466E735B696753746174696349645D290D0A20202020202077696E646F772E766E614967416374696F6E466E735B696753746174696349645D3D205B5D3B0D0A2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(8) := '2020202020202020202020202020202020202020202020202020202020202020202020200D0A2020202077696E646F772E766E614967416374696F6E466E735B696753746174696349645D2E70757368287B0D0A202020202020616374696F6E4E616D65';
wwv_flow_api.g_varchar2_table(9) := '2C0D0A202020202020616374696F6E466E2C0D0A202020202020616374696F6E4C6162656C0D0A202020207D293B0D0A20207D0D0A090D0A090D0A202073746174696320696E6974546F6F6C6261724461746128696753746174696349642C20746F6F6C';
wwv_flow_api.g_varchar2_table(10) := '62617244617461297B0D0A2020096C6574206967427574746F6E73203D2077696E646F772E766E614967427574746F6E732026262077696E646F772E766E614967427574746F6E735B696753746174696349645D207C7C205B5D3B0D0A202020200D0A20';
wwv_flow_api.g_varchar2_table(11) := '202020696628746F6F6C62617244617461297B0D0A202020202020666F72286C65742069203D20303B2069203C206967427574746F6E732E6C656E6774683B20692B2B297B0D0A202020202020096C657420746F6F6C626172506F736974696F6E3B0D0A';
wwv_flow_api.g_varchar2_table(12) := '20202020202020200D0A20202020202020206966286967427574746F6E735B695D2E746F6F6C626172506F736974696F6E297B0D0A202020202020202009746F6F6C626172506F736974696F6E203D20746F6F6C626172446174612E746F6F6C62617246';
wwv_flow_api.g_varchar2_table(13) := '696E64286967427574746F6E735B695D2E746F6F6C626172506F736974696F6E293B0D0A202020202020202020200D0A20202020202020202020696628746F6F6C626172506F736974696F6E297B0D0A2020202020202020202009746F6F6C626172506F';
wwv_flow_api.g_varchar2_table(14) := '736974696F6E2E636F6E74726F6C732E70757368286967427574746F6E735B695D2E636F6E666967293B0D0A202020202020202020097D656C73657B0D0A2020202020202020202009617065782E64656275672E7761726E2860436F756C64206E6F7420';
wwv_flow_api.g_varchar2_table(15) := '696E697469616C697A6520564E4120496E746572616374697665204772696420427574746F6E2C20636F756C64206E6F742066696E6420746F6F6C62617220706F736974696F6E20247B6967427574746F6E735B695D2E746F6F6C626172506F73697469';
wwv_flow_api.g_varchar2_table(16) := '6F6E7D20696E20496E746572616374697665204772696420247B696753746174696349647D60293B0D0A202020202020202020207D0D0A20202020202020207D0D0A2020202020202020656C73657B0D0A202020202020202009617065782E6465627567';
wwv_flow_api.g_varchar2_table(17) := '2E7761726E2827436F756C64206E6F7420696E697469616C697A6520564E4120496E746572616374697665204772696420427574746F6E2C206D697373696E6720746F6F6C62617220706F736974696F6E27293B0D0A20202020202020207D0D0A202020';
wwv_flow_api.g_varchar2_table(18) := '2020207D0D0A202020207D0D0A20202020656C7365207B0D0A202020202020617065782E64656275672E7761726E2827436F756C64206E6F7420696E697469616C697A6520564E4120496E746572616374697665204772696420427574746F6E2C206D69';
wwv_flow_api.g_varchar2_table(19) := '7373696E6720746F6F6C626172206461746127293B0D0A202020207D0D0A20207D0D0A20200D0A202073746174696320696E6974416374696F6E7328696753746174696349642C20616374696F6E73297B0D0A2020096C6574206967416374696F6E466E';
wwv_flow_api.g_varchar2_table(20) := '73203D2077696E646F772E766E614967416374696F6E466E732026262077696E646F772E766E614967416374696F6E466E735B696753746174696349645D207C7C205B5D3B0D0A202020200D0A20202020696628616374696F6E73297B0D0A2020202020';
wwv_flow_api.g_varchar2_table(21) := '20666F72286C65742069203D20303B2069203C206967416374696F6E466E732E6C656E6774683B20692B2B297B0D0A20202020202009696628747970656F66206967416374696F6E466E735B695D2E616374696F6E466E203D3D202766756E6374696F6E';
wwv_flow_api.g_varchar2_table(22) := '27297B0D0A20202020202020202020616374696F6E732E616464287B0D0A2020202020202020202020206E616D653A206967416374696F6E466E735B695D2E616374696F6E4E616D652C0D0A2020202020202020202020206C6162656C3A206967416374';
wwv_flow_api.g_varchar2_table(23) := '696F6E466E735B695D2E616374696F6E4C6162656C2C0D0A202020202020202020202020616374696F6E3A206967416374696F6E466E735B695D2E616374696F6E466E0D0A202020202020202020207D293B0D0A2020202020202020092F2F6967416374';
wwv_flow_api.g_varchar2_table(24) := '696F6E466E735B695D28616374696F6E732C2069675374617469634964293B0D0A20202020202020207D0D0A2020202020202020656C73657B0D0A202020202020202009617065782E64656275672E7761726E2827436F756C64206E6F7420696E697469';
wwv_flow_api.g_varchar2_table(25) := '616C697A6520564E4120496E746572616374697665204772696420427574746F6E20616374696F6E732C20616374696F6E206973206E6F7420612076616C69642066756E6374696F6E27293B0D0A20202020202020207D0D0A2020202020207D0D0A2020';
wwv_flow_api.g_varchar2_table(26) := '20207D0D0A20202020656C7365207B0D0A202020202020617065782E64656275672E7761726E2827436F756C64206E6F7420696E697469616C697A6520564E4120496E746572616374697665204772696420427574746F6E20616374696F6E732C206D69';
wwv_flow_api.g_varchar2_table(27) := '7373696E6720616374696F6E7327293B0D0A202020207D0D0A20207D0D0A7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(160112354787494980)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_file_name=>'vna_ig_button.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '636C61737320566E614967427574746F6E7B73746174696320616464427574746F6E286E2C74297B77696E646F772E766E614967427574746F6E737C7C2877696E646F772E766E614967427574746F6E733D5B5D292C77696E646F772E766E6149674275';
wwv_flow_api.g_varchar2_table(2) := '74746F6E735B6E5D7C7C2877696E646F772E766E614967427574746F6E735B6E5D3D5B5D292C77696E646F772E766E614967427574746F6E735B6E5D2E707573682874297D73746174696320616464427574746F6E416374696F6E73466E286E2C742C69';
wwv_flow_api.g_varchar2_table(3) := '2C6F297B77696E646F772E766E614967416374696F6E466E737C7C2877696E646F772E766E614967416374696F6E466E733D5B5D292C77696E646F772E766E614967416374696F6E466E735B6E5D7C7C2877696E646F772E766E614967416374696F6E46';
wwv_flow_api.g_varchar2_table(4) := '6E735B6E5D3D5B5D292C77696E646F772E766E614967416374696F6E466E735B6E5D2E70757368287B616374696F6E4E616D653A742C616374696F6E466E3A692C616374696F6E4C6162656C3A6F7D297D73746174696320696E6974546F6F6C62617244';
wwv_flow_api.g_varchar2_table(5) := '617461286E2C74297B6C657420693D77696E646F772E766E614967427574746F6E73262677696E646F772E766E614967427574746F6E735B6E5D7C7C5B5D3B6966287429666F72286C6574206F3D303B6F3C692E6C656E6774683B6F2B2B297B6C657420';
wwv_flow_api.g_varchar2_table(6) := '613B695B6F5D2E746F6F6C626172506F736974696F6E3F28613D742E746F6F6C62617246696E6428695B6F5D2E746F6F6C626172506F736974696F6E292C613F612E636F6E74726F6C732E7075736828695B6F5D2E636F6E666967293A617065782E6465';
wwv_flow_api.g_varchar2_table(7) := '6275672E7761726E2860436F756C64206E6F7420696E697469616C697A6520564E4120496E746572616374697665204772696420427574746F6E2C20636F756C64206E6F742066696E6420746F6F6C62617220706F736974696F6E20247B695B6F5D2E74';
wwv_flow_api.g_varchar2_table(8) := '6F6F6C626172506F736974696F6E7D20696E20496E746572616374697665204772696420247B6E7D6029293A617065782E64656275672E7761726E2822436F756C64206E6F7420696E697469616C697A6520564E4120496E746572616374697665204772';
wwv_flow_api.g_varchar2_table(9) := '696420427574746F6E2C206D697373696E6720746F6F6C62617220706F736974696F6E22297D656C736520617065782E64656275672E7761726E2822436F756C64206E6F7420696E697469616C697A6520564E4120496E74657261637469766520477269';
wwv_flow_api.g_varchar2_table(10) := '6420427574746F6E2C206D697373696E6720746F6F6C626172206461746122297D73746174696320696E6974416374696F6E73286E2C74297B6C657420693D77696E646F772E766E614967416374696F6E466E73262677696E646F772E766E6149674163';
wwv_flow_api.g_varchar2_table(11) := '74696F6E466E735B6E5D7C7C5B5D3B6966287429666F72286C6574206E3D303B6E3C692E6C656E6774683B6E2B2B292266756E6374696F6E223D3D747970656F6620695B6E5D2E616374696F6E466E3F742E616464287B6E616D653A695B6E5D2E616374';
wwv_flow_api.g_varchar2_table(12) := '696F6E4E616D652C6C6162656C3A695B6E5D2E616374696F6E4C6162656C2C616374696F6E3A695B6E5D2E616374696F6E466E7D293A617065782E64656275672E7761726E2822436F756C64206E6F7420696E697469616C697A6520564E4120496E7465';
wwv_flow_api.g_varchar2_table(13) := '72616374697665204772696420427574746F6E20616374696F6E732C20616374696F6E206973206E6F7420612076616C69642066756E6374696F6E22293B656C736520617065782E64656275672E7761726E2822436F756C64206E6F7420696E69746961';
wwv_flow_api.g_varchar2_table(14) := '6C697A6520564E4120496E746572616374697665204772696420427574746F6E20616374696F6E732C206D697373696E6720616374696F6E7322297D7D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(160114386112496711)
,p_plugin_id=>wwv_flow_api.id(304476015496908876)
,p_file_name=>'vna_ig_button.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
prompt --application/end_environment
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
