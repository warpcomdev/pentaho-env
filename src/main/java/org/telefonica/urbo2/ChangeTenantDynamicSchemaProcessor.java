/*
 *
 * Copyright 2020 Telefónica Soluciones de Informática y Comunicaciones de España, S.A.U.
 *
 * This file is part of Pentaho DSP.
 *
 * Pentaho DSP is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Pentaho DSP is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero
 * General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with Orion Context Broker. If not, see http://www.gnu.org/licenses/.
 *
 * For those usages not covered by this license please contact with
 * sc_support at telefonica dot com
 *
 */

package org.telefonica.urbo2;

import mondrian.olap.Util;
import mondrian.spi.impl.FilterDynamicSchemaProcessor;

import java.io.InputStream;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.pentaho.platform.api.engine.IPentahoSession;
import org.pentaho.platform.engine.core.system.PentahoSessionHolder;

public class ChangeTenantDynamicSchemaProcessor extends FilterDynamicSchemaProcessor {
    Logger logger = LoggerFactory.getLogger( ChangeTenantDynamicSchemaProcessor.class );

    @Override
    protected String filter(final String schemaUrl, final Util.PropertyList connectInfo, final InputStream stream)
            throws java.lang.Exception {
        String originalSchema = super.filter(schemaUrl, connectInfo, stream);
        IPentahoSession session = PentahoSessionHolder.getSession();
        String username = session.getName();
        String schema = username;
        if(username == null || username.isEmpty() || username.equalsIgnoreCase("admin")){
            schema = "pentaho";
        }
        String modifiedSchema = originalSchema.replace("%TENANT%", schema);
        logger.debug("########## Esquema utilizado: " + schema + " para el usuario: " + username);
        return modifiedSchema;
    }

}