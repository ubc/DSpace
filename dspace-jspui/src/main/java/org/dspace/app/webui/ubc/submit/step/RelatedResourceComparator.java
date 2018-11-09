/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.submit.step;

import java.util.Comparator;
import org.dspace.app.webui.ubc.retriever.RelatedResource;

/**
 *
 * @author john
 */
public class RelatedResourceComparator implements Comparator<RelatedResource>
{
	@Override
	public int compare(RelatedResource a, RelatedResource b)
	{
		return a.getTitle().compareToIgnoreCase(b.getTitle());
	}
}
