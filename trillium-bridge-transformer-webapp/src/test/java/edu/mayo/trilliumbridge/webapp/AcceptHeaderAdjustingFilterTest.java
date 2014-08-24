package edu.mayo.trilliumbridge.webapp;

import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

import static junit.framework.Assert.assertEquals;

/**
 */
public class AcceptHeaderAdjustingFilterTest {

    @Test
    public void testGetFormatTypeFromParameterXml() throws Exception {
        AcceptHeaderAdjustingFilter filter = new AcceptHeaderAdjustingFilter();

        Map<String,String[]> map = new HashMap<String,String[]>();
        map.put("format", new String[]{"xml"});

        assertEquals("application/xml", filter.getFormatTypeFromParameter(map));
    }

    @Test
    public void testGetFormatTypeFromParameterHtml() throws Exception {
        AcceptHeaderAdjustingFilter filter = new AcceptHeaderAdjustingFilter();

        Map<String,String[]> map = new HashMap<String,String[]>();
        map.put("format", new String[]{"html"});

        assertEquals("text/html", filter.getFormatTypeFromParameter(map));
    }

    @Test
    public void testGetFormatTypeFromParameterPdf() throws Exception {
        AcceptHeaderAdjustingFilter filter = new AcceptHeaderAdjustingFilter();

        Map<String,String[]> map = new HashMap<String,String[]>();
        map.put("format", new String[]{"pdf"});

        assertEquals("application/pdf", filter.getFormatTypeFromParameter(map));
    }

}
